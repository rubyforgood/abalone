require 'rails_helper'

describe "upload TaggedAnimalAssessment category", type: :feature do

  let(:user) { User.create({ :email => "admin@test.com",
                :password => "password",
                :password_confirmation => "password" }) }

  let(:valid_file) { "db/sample_data_files/tagged_animal_assessment/Tagged_assessment_12172018 (original).csv" }
  let(:invalid_file) { "spec/support/csv/invalid_headers.csv" }
  let(:incomplete_data_file) { "spec/support/csv/Tagged_assessment_03172018-invalid-rows.csv" }
  let(:expected_success_message) { 'Successfully queued spreadsheet for import' }

  before do
    sign_in user
    visit new_file_upload_path
  end

  context 'when user successfully uploads a CSV with no errors' do
    it "creates new ProcessedFile record with 'Processed' status " do
      upload_file("Tagged Animal Assessment", valid_file)

      processed_file = ProcessedFile.last
      expect(ProcessedFile.count).to eq 1
      expect(processed_file.status).to eq "Processed"
      expect(processed_file.job_errors).to eq(nil)
      expect(processed_file.job_stats).to eq(
        { "row_count"=>201,
          "rows_imported"=>201,
          "shl_case_numbers" => {"SF16-9A"=>100, "SF16-9B"=>21, "SF16-9C"=>11, "SF16-9D"=>69},
        }
      )
      expect(page).to have_content expected_success_message
    end
  end

  context 'when user uploads a CSV with invalid headers' do
    it "creates new ProcessedFile record with 'Failed' status" do
      upload_file("Tagged Animal Assessment", invalid_file)

      processed_file = ProcessedFile.last
      expect(ProcessedFile.count).to eq 1
      expect(processed_file.status).to eq "Failed"
      expect(processed_file.job_errors).to eq "Does not have valid headers. Data not imported!"
      expect(processed_file.job_stats).to eq({})
      expect(page).to have_content expected_success_message
    end
  end

  context 'when user upload a CSV that has been already processed' do
    before do
      FactoryBot.create :processed_file,
        status: 'Processed',
        original_filename: 'Tagged_assessment_12172018 (original).csv'
    end

    it "creates new ProcessedFile record with 'Failed' status" do
      upload_file("Tagged Animal Assessment", valid_file)

      processed_file = ProcessedFile.where(status: "Failed").first
      expect(ProcessedFile.count).to eq 2
      expect(processed_file.job_errors).to eq "Already processed a file with the same name. Data not imported!"
      expect(processed_file.job_stats).to eq({})
      expect(page).to have_content expected_success_message
    end
  end

  context 'when user upload file with invalid rows' do
    it "creates new ProcessedFile record with 'Processed' status" do
      upload_file("Tagged Animal Assessment", incomplete_data_file)

      processed_file = ProcessedFile.last
      expect(ProcessedFile.count).to eq 1
      expect(processed_file.status).to eq "Processed with errors - only re-upload fixed rows to avoid data duplication"
      expect(processed_file.job_errors).to eq(nil)
      expect(processed_file.job_stats).to eq(
        { "row_count"=>201,
          "rows_imported"=>199,
          "rows_not_imported"=>2,
          "shl_case_numbers" => {"SF16-9A"=>98, "SF16-9B"=>21, "SF16-9C"=>11, "SF16-9D"=>69}
        }
      )
      expect(page).to have_content expected_success_message
    end
  end
end
