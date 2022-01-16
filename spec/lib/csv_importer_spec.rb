require "rails_helper"

RSpec.describe CsvImporter do
  subject(:csv_importer) do
    CsvImporter.new(target_model, file, processed_file.id, organization)
  end

  let(:target_model) { Measurement }
  let!(:organization) { create(:organization) }
  let!(:measurement_type1) { create(:measurement_type, organization: organization) }
  let!(:measurement_type2) { create(:measurement_type, name: 'count', unit: 'number', organization: organization) }
  let!(:measurement_type3) { create(:measurement_type, name: 'gonad score', unit: 'number', organization: organization) }
  let!(:cohort) { create(:cohort, name: 'Test Cohort', organization: organization) }
  let!(:exit_type) { create(:exit_type, organization: organization) }

  describe "#process" do
    let(:processed_file) { create(:processed_file, organization: organization) }

    context "when csv file is perfect" do
      context "with Measurement records" do
        let(:file) { File.read(Rails.root.join("spec/fixtures/files/basic_custom_measurement.csv")) }

        it "imports all the Measurement records" do
          expect { csv_importer.call }
            .to change { Measurement.count }
            .by(6)
        end
      end

      context "with MortalityEvent records" do
        let(:target_model) { MortalityEvent }
        let(:file) { File.read(Rails.root.join("spec/fixtures/files/basic_custom_mortality_events.csv")) }

        it "imports all the Mortality Event records" do
          expect { csv_importer.call }
            .to change { MortalityEvent.count }
            .by(2)
        end
      end
    end

    context "when the csv file has extra empty lines" do
      let(:file) do
        File.read(Rails.root.join("spec/fixtures/files/basic_custom_measurement.csv"))
            .concat("\n\n\n\n\n")
      end

      it "ignores the empty lines and imports the valid rows" do
        expect { csv_importer.call }
          .to change { Measurement.count }
          .by(6)
      end
    end

    context "when there are errors importing a row" do
      let(:file) { File.read(Rails.root.join("spec", "fixtures", "files", "basic_custom_measurement_invalid.csv")) }

      it "does not import any record" do
        expect { csv_importer.call }
          .not_to change { Measurement.count }
      end

      it "provides error details" do
        expect { csv_importer.call }
          .not_to change { Measurement.count }
        expect(csv_importer.errored?).to eq(true)
        expect(csv_importer.error_details.empty?).to eq(false)
      end

      it "provides error messages" do
        expect { csv_importer.call }
          .not_to change { Measurement.count }
        expect(csv_importer.errored?).to eq(true)
        expect(csv_importer.error_messages['Row 2']).to contain_exactly("Value can't be blank")
        expect(csv_importer.error_messages['Row 3']).to contain_exactly("Measurement type must exist")
      end
    end
  end

  describe "#process" do
    let(:processed_file) { create(:processed_file, organization: organization) }
    let!(:enclosure) { create(:enclosure, name: "Test Enclosure") }

    context "allows the upload of custom enclosure measurements (without notes)" do
      let(:file) { File.read(Rails.root.join("spec/fixtures/files/basic_custom_measurement.csv")) }

      it "saves the measurements" do
        expect { csv_importer.call }
          .to change { Measurement.count }
          .by(6)
      end

      it "attaches the proper info and relationships for measurements (existing enclosure)" do
        csv_importer.call
        e = Enclosure.where(name: "Test Enclosure").last
        measurement = e.measurements.last
        expect(measurement.value).to eq "42"
        expect(measurement.measurement_event.name).to eq "September Survey"
      end
    end

    context "allows the upload of expanded custom enclosure measurements (without notes)" do
      let(:file) { File.read(Rails.root.join("spec/fixtures/files/custom_measurements_multiple_models.csv")) }
      let!(:new_cohort) { create(:cohort, name: "New Cohort", enclosure: enclosure, organization: organization) }

      it "saves the measurements" do
        expect { csv_importer.call }
          .to change { Measurement.count }
          .by(1)
      end

      it "attaches the proper info and relationships for measurements (existing enclosure)" do
        csv_importer.call
        measurement = enclosure.cohort.measurements.last
        expect(measurement.value).to eq "12"
        expect(measurement.measurement_event.name).to eq "Monthly Count"
        expect(measurement.subject.name).to eq "New Cohort"
      end
    end
  end
end
