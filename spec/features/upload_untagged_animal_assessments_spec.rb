require 'rails_helper'

describe "upload UntaggedAnimalAssessment category", type: :feature do
  let(:user) { User.create({ :email => "admin@test.com",
                :password => "password",
                :password_confirmation => "password" }) }

  let(:valid_file) { "db/sample_data_files/untagged_animal_assessment/Untagged_assessment_03122018.csv" }
  let(:invalid_file) { "spec/support/csv/invalid_headers.csv" }
  let(:incomplete_data_file) { "spec/support/csv/Untagged_assessment_03122018-invalid-rows.csv" }
  let(:expected_success_message) { 'Successfully queued spreadsheet for import' }
  let(:temporary_file) { create(:temporary_file, contents: File.read(valid_file)) }

  before do
    sign_in user
    visit new_file_upload_path
  end

  context 'when user successfully uploads a CSV with no errors' do
    it "creates new ProcessedFile record with 'Processed' status " do
      upload_file("Untagged Animal Assessment", valid_file)

      processed_file = ProcessedFile.last
      expect(ProcessedFile.count).to eq 1
      expect(processed_file.status).to eq "Processed"
      expect(processed_file.job_errors).to eq(nil)
      expect(processed_file.job_stats).to eq(
        { "row_count"=>250,
          "rows_imported"=>250,
          "shl_case_numbers" => {"SF16-9A"=>50, "SF16-9B"=>50, "SF16-9C"=>50, "SF16-9D"=>50, "SF16-9E"=>50},
        }
      )
      expect(page).to have_content expected_success_message
    end
  end

  context 'when user uploads a CSV with invalid headers' do
    it "creates new ProcessedFile record with 'Failed' status" do
      upload_file("Untagged Animal Assessment", invalid_file)

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
        filename: 'Untagged_assessment_03122018.csv',
        cateogry: 'Untagged Animal Assessment',
        status: 'Processed',
        temporary_file_id: temporary_file.id
    end

    it "creates new ProcessedFile record with 'Failed' status" do
      upload_file("Untagged Animal Assessment", valid_file)

      processed_file = ProcessedFile.where(status: "Failed").first
      expect(ProcessedFile.count).to eq 2
      expect(processed_file.job_errors).to eq "Already processed a file on #{processed_file.created_at.strftime('%m/%d/%Y')} with the same name: Untagged_assessment_03122018.csv. Data not imported!"
      expect(processed_file.job_stats).to eq({})
      expect(page).to have_content expected_success_message
    end
  end

  context 'when user upload file with invalid rows' do
    it "creates new ProcessedFile record with 'Failed' status" do
      upload_file("Untagged Animal Assessment", incomplete_data_file)

      processed_file = ProcessedFile.last
      expect(ProcessedFile.count).to eq 1
      expect(processed_file.status).to eq "Failed"
      expect(processed_file.job_errors).to eq("Does not have valid row(s). Data not imported!")
      expect(processed_file.job_stats).to eq({"row_number_2"=>{"cohort"=>[{"error"=>"blank"}]}, "row_number_3"=>{"growout_rack"=>[{"error"=>"blank"}]}})
      expect(page).to have_content expected_success_message
    end
  end
end
