require 'rails_helper'

describe "upload TaggedAnimalAssessment category", type: :feature do
  let(:user) { create(:user) }
  let(:valid_file) { "#{Rails.root}/db/sample_data_files/tagged_animal_assessment/Tagged_assessment_12172018 (original).csv" }
  let(:second_valid_file) { "#{Rails.root}/spec/support/csv/Tagged_assessment_03172018.csv" }
  let(:invalid_file) { "#{Rails.root}/spec/support/csv/invalid_headers.csv" }
  let(:incomplete_data_file) { "#{Rails.root}/spec/support/csv/Tagged_assessment_03172018-invalid-rows.csv" }
  let(:expected_success_message) { 'Successfully queued spreadsheet for import' }
  let(:temporary_file) { create(:temporary_file, contents: File.read(valid_file)) }

  before do
    sign_in user
    visit new_file_upload_path
  end

  context 'when user successfully uploads two CSVs with no errors' do
    it "creates two new ProcessedFile records with 'Processed' status " do
      expect do
        upload_file("Tagged Animal Assessment", [valid_file, second_valid_file])
      end.to change { ProcessedFile.count }.by(2)

      ProcessedFile.all.each do |processed_file|
        expect(processed_file.status).to eq "Processed"
        expect(processed_file.job_errors).to eq(nil)
        expect(processed_file.job_stats).to eq(
          {
            "row_count" => 201,
            "rows_imported" => 201,
            "shl_case_numbers" => {"SF16-9A"=>100, "SF16-9B"=>21, "SF16-9C"=>11, "SF16-9D"=>69}
          }
        )
      end
      expect(page).to have_content expected_success_message
    end
  end

  context 'when user uploads a CSV with invalid headers' do
    it "creates new ProcessedFile record with 'Failed' status" do
      upload_file("Tagged Animal Assessment", invalid_file)

      processed_file = ProcessedFile.last
      expect(ProcessedFile.count).to eq 1
      expect(processed_file.status).to eq "Failed"
      expect(processed_file.job_errors).to eq "Does not have valid header(s). Data not imported!"
      expect(processed_file.job_stats).to eq({})
      expect(page).to have_content expected_success_message
    end
  end

  context 'when user upload a CSV that has been already processed' do
    before do
      FactoryBot.create :processed_file,
                        status: 'Processed',
                        temporary_file_id: temporary_file.id
    end

    it "creates new ProcessedFile record with 'Failed' status" do
      upload_file("Tagged Animal Assessment", valid_file)

      processed_file = ProcessedFile.where(status: "Failed").first
      expect(ProcessedFile.count).to eq 2
      expect(processed_file.job_errors).to eq "Already processed a file on #{processed_file.created_at.strftime('%m/%d/%Y')} with the same name: Tagged_assessment_12172018 (original).csv. Data not imported!"
      expect(processed_file.job_stats).to eq({})
      expect(page).to have_content expected_success_message
    end
  end

  context 'when user upload file with invalid rows' do
    it "creates new ProcessedFile record with 'Failed' status" do
      upload_file("Tagged Animal Assessment", incomplete_data_file)

      processed_file = ProcessedFile.last
      expect(ProcessedFile.count).to eq 1
      expect(processed_file.status).to eq "Failed"
      expect(processed_file.job_errors).to eq("Does not have valid row(s). Data not imported!")
      expect(processed_file.job_stats).to eq({"row_number_2"=>{"shl_case_number"=>[{"error"=>"blank"}]}, "row_number_3"=>{"tag"=>[{"error"=>"blank"}]}})
      expect(page).to have_content expected_success_message
    end
  end
end
