require "rails_helper"

RSpec.describe CsvImporter do
  let!(:organization) { create(:organization) }

  describe "#process" do
    let(:processed_file) { create(:processed_file) }
    let(:category_name) { "Measurement" }

    context "when csv file is perfect" do
      it "imports all the records" do
        skip
        file = File.read(Rails.root.join("spec/fixtures/basic_custom_measurement.csv"))

        expect do
          CsvImporter.new(file, category_name, processed_file.id, organization).call
        end.to change { Measurement.count }.by 6
      end
    end

    # This is being ignored because the only available report does not contain a field that needs to be converted, making the import impossible to fail
    # basic_custom_measurement_invalid.csv will need to updated with invalid data
    context "when there're errors importing a row" do
      pending "does not import any record" do
        skip
        file = File.read(Rails.root.join("spec", "support", "csv", "basic_custom_measurement_invalid.csv"))

        expect do
          CsvImporter.new(file, category_name, processed_file.id, organization).call
        end.not_to change { Measurement.count }
      end

      pending "provides error details" do
        skip
        file = File.read(Rails.root.join("spec", "support", "csv", "basic_custom_measurement_invalid.csv"))
        importer = CsvImporter.new(file, category_name, processed_file.id, organization)

        expect do
          importer.call
        end.not_to change { Measurement.count }
        expect(importer.errored?).to eq(true)
        expect(importer.error_details.empty?).to eq(false)
      end
    end
  end

  describe "#process" do
    let(:processed_file) { create(:processed_file) }
    let(:category_name) { "Measurement" }

    context "allows the upload of custom enclosure measurments (without notes)" do
      let(:file) { File.read(Rails.root.join("spec/fixtures/basic_custom_measurement.csv")) }
      it "saves the measurements" do
        skip
        expect do
          CsvImporter.new(file, category_name, processed_file.id, organization).call
        end.to change { Measurement.count }.by(6)
      end

      it "attaches the proper info and relationships for measurements (existing enclosure)" do
        skip
        CsvImporter.new(file, category_name, processed_file.id, organization).call
        enclosure = Enclosure.where(name: "AB-17").last
        measurement = enclosure.measurements.find_by!(name: "Flavor")
        expect(measurement.value).to eq "WAY too salty"
        expect(measurement.measurement_event.name).to eq "Michael Drinks the Water"
      end
    end

    context "allows the upload of expanded custom enclosure measurements (without notes)" do
      let(:file) { File.read(Rails.root.join("spec/fixtures/custom_measurements_multiple_models.csv")) }
      before do
        FactoryBot.create(:cohort, name: "Adams Family")
      end

      it "saves the measurements" do
        skip
        expect do
          CsvImporter.new(file, category_name, processed_file.id, organization).call
        end.to change { Measurement.count }.by(1)
      end

      it "attaches the proper info and relationships for measurements (existing enclosure)" do
        skip
        CsvImporter.new(file, category_name, processed_file.id, organization).call
        enclosure = Enclosure.find_by!(name: "Support Rack 3")
        measurement = enclosure.measurements.find_by!(name: "Flavor")
        expect(measurement.value).to eq "Salty"
        expect(measurement.measurement_event.name).to eq "Michael Drinks the Water"
        expect(measurement.cohort.name).to eq "Adams Family"
        expect(measurement.animal.tag).to eq "G123"
      end
    end
  end
end
