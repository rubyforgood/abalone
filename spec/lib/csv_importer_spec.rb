require "rails_helper"

RSpec.describe CsvImporter do
  describe "#process" do
    let(:processed_file) { create(:processed_file) }
    let(:category_name) { "Tagged Animal Assessment" }

    context "when csv file is perfect" do
      it "imports all the records" do
        file = File.read(Rails.root.join("spec/support/csv/Tagged_assessment_valid_values.csv"))

        expect do
          CsvImporter.new(file, category_name, processed_file.id).call
        end.to change { TaggedAnimalAssessment.count }.by 3
      end
    end

    context "when there're errors importing a row" do
      it "does not import any record" do
        file = File.read(Rails.root.join("spec", "support", "csv", "Tagged_assessment_invalid_values.csv"))

        expect do
          CsvImporter.new(file, category_name, processed_file.id).call
        end.not_to change { TaggedAnimalAssessment.count }
      end

      it "provides error details" do
        file = File.read(Rails.root.join("spec", "support", "csv", "Tagged_assessment_invalid_values.csv"))
        importer = CsvImporter.new(file, category_name, processed_file.id)

        expect do
          importer.call
        end.not_to change { TaggedAnimalAssessment.count }
        expect(importer.errored?).to eq(true)
        expect(importer.error_details.empty?).to eq(false)
      end
    end
  end

  describe "#process" do
    let(:processed_file) { create(:processed_file) }
    let(:category_name) { "Measurement" }

    context "allows the upload of custom tank measurments (without notes)" do
      let(:file) { File.read(Rails.root.join("spec/fixtures/basic_custom_measurement.csv")) }
      it "saves the measurements" do
        expect do
          CsvImporter.new(file, category_name, processed_file.id).call
        end.to change { Measurement.count }.by(6)
      end

      it "attaches the proper info and relationships for measurements (existing tank)" do
        CsvImporter.new(file, category_name, processed_file.id).call
        tank = Tank.find_by!(name: "AB-17")
        measurement = tank.measurements.find_by!(name: "Flavor")
        expect(measurement.value).to eq "WAY too salty"
        expect(measurement.measurement_event.name).to eq "Michael Drinks the Water"
      end
    end

    context "allows the upload of expanded custom tank measurements (without notes)" do
      let(:file) { File.read(Rails.root.join("spec/fixtures/custom_measurements_multiple_models.csv")) }
      before do
        FactoryBot.create(:family, name: "Adams Family")
      end

      it "saves the measurements" do
        expect do
          CsvImporter.new(file, category_name, processed_file.id).call
        end.to change { Measurement.count }.by(1)
      end

      it "attaches the proper info and relationships for measurements (existing tank)" do
        CsvImporter.new(file, category_name, processed_file.id).call
        tank = Tank.find_by!(name: "Support Rack 3")
        measurement = tank.measurements.find_by!(name: "Flavor")
        expect(measurement.value).to eq "Salty"
        expect(measurement.measurement_event.name).to eq "Michael Drinks the Water"
        expect(measurement.family.name).to eq "Adams Family"
        expect(measurement.animal.pii_tag).to eq 123
      end
    end
  end
end
