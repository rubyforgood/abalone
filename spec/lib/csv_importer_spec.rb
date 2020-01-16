require "rails_helper"

RSpec.describe CsvImporter do
  describe "#process" do
    let(:processed_file) { create(:processed_file) }
    let(:category_name) { "Tagged Animal Assessment" }

    context "when csv file is perfect" do
      it "imports all the records" do
        filename = Rails.root.join("spec", "support", "csv", "Tagged_assessment_valid_values.csv").to_s

        expect do
          CsvImporter.import(filename, category_name, processed_file.id)
        end.to change { TaggedAnimalAssessment.count }.by 3
      end
    end

    context "when there're errors importing a row" do
      it "does not import any record" do
        filename = Rails.root.join("spec", "support", "csv", "Tagged_assessment_invalid_values.csv").to_s

        expect do
          CsvImporter.import(filename, category_name, processed_file.id)
        end.not_to change { TaggedAnimalAssessment.count }
      end
    end
  end
end
