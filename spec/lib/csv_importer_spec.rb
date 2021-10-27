require "rails_helper"

RSpec.describe CsvImporter do
  let!(:organization) { create(:organization) }
  let!(:measurement_type1) { create(:measurement_type, organization: organization) }
  let!(:measurement_type2) { create(:measurement_type, name: 'count', unit: 'number', organization: organization) }
  let!(:measurement_type3) { create(:measurement_type, name: 'gonad score', unit: 'number', organization: organization) }
  let!(:cohort) { create(:cohort, name: 'Test Cohort', organization: organization) }
  let!(:exit_type) { create(:exit_type, organization: organization) }

  describe "#process" do
    let(:processed_file) { create(:processed_file, organization: organization) }
    let(:category_name) { "Measurement" }

    context "when csv file is perfect" do
      it "imports all the Measurement records" do
        file = File.read(Rails.root.join("spec/fixtures/files/basic_custom_measurement.csv"))

        expect do
          CsvImporter.new(file, category_name, processed_file.id, organization).call
        end.to change { Measurement.count }.by 6
      end

      it "imports all the Mortality Event records" do
        file = File.read(Rails.root.join("spec/fixtures/files/basic_custom_measurement.csv"))

        expect do
          CsvImporter.new(file, category_name, processed_file.id, organization).call
        end.to change { MortalityEvent.count }.by 2
      end
    end

    context "when the csv file has extra empty lines" do
      it "ignores the empty lines and imports the valid rows" do
        orginal_file = File.read(Rails.root.join("spec/fixtures/files/basic_custom_measurement.csv"))

        tempfile = Tempfile.new
        tempfile.write(orginal_file)
        5.times { tempfile.write("\n") }
        tempfile.rewind

        file = File.read(tempfile.path)

        expect do
          CsvImporter.new(file, category_name, processed_file.id, organization).call
        end.to change { Measurement.count }.by 6
      end
    end

    context "when there are errors importing a row" do
      it "does not import any record" do
        file = File.read(Rails.root.join("spec", "fixtures", "files", "basic_custom_measurement_invalid.csv"))

        expect do
          CsvImporter.new(file, category_name, processed_file.id, organization).call
        end.not_to change { Measurement.count }
      end

      it "provides error details" do
        file = File.read(Rails.root.join("spec", "fixtures", "files", "basic_custom_measurement_invalid.csv"))
        importer = CsvImporter.new(file, category_name, processed_file.id, organization)

        expect do
          importer.call
        end.not_to change { Measurement.count }
        expect(importer.errored?).to eq(true)
        expect(importer.error_details.empty?).to eq(false)
      end

      it "provides error messages" do
        file = File.read(Rails.root.join("spec", "fixtures", "files", "basic_custom_measurement_invalid.csv"))
        importer = CsvImporter.new(file, category_name, processed_file.id, organization)

        expect do
          importer.call
        end.not_to change { Measurement.count }
        expect(importer.errored?).to eq(true)
        expect(importer.error_messages.empty?).to eq(false)
        expect(importer.error_messages.keys.length).to eq(1)
        expect(importer.error_messages.values.length).to eq(1)
        expect(importer.error_messages.keys.first).to eq('Row 2')
        expect(importer.error_messages['Row 2']).to contain_exactly("Value can't be blank")
      end
    end
  end

  describe "#process" do
    let(:processed_file) { create(:processed_file, organization: organization) }
    let(:category_name) { "Measurement" }
    let!(:enclosure) { create(:enclosure, name: "Test Enclosure") }

    context "allows the upload of custom enclosure measurements (without notes)" do
      let(:file) { File.read(Rails.root.join("spec/fixtures/files/basic_custom_measurement.csv")) }
      it "saves the measurements" do
        expect do
          CsvImporter.new(file, category_name, processed_file.id, organization).call
        end.to change { Measurement.count }.by(6)
      end

      it "attaches the proper info and relationships for measurements (existing enclosure)" do
        CsvImporter.new(file, category_name, processed_file.id, organization).call
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
        expect do
          CsvImporter.new(file, category_name, processed_file.id, organization).call
        end.to change { Measurement.count }.by(1)
      end

      it "attaches the proper info and relationships for measurements (existing enclosure)" do
        CsvImporter.new(file, category_name, processed_file.id, organization).call
        measurement = enclosure.cohort.measurements.last
        expect(measurement.value).to eq "12"
        expect(measurement.measurement_event.name).to eq "Monthly Count"
        expect(measurement.subject.name).to eq "New Cohort"
      end
    end
  end
end
