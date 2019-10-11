require 'rails_helper'

describe "upload CSV files for TaggedAnimalAssessmentJob", type: :feature do

  let(:valid_file) { "db/sample_data_files/tagged_animal_assessment/Tagged_assessment_12172018 (original).csv" }
  let(:invalid_headers_file) { "db/sample_data_files/tagged_animal_assessment/Tagged_assessment_03172018-invalid-header.csv" }

  context 'when user successfully uploads a CSV with no errors' do
    it "creates new ProcessedFile record with processed status " do
      visit 'file_uploads/new'

      select "Tagged Animal Assessment", from: 'category'
      attach_file('input_file', Rails.root + valid_file)
      click_on 'Submit'

      expect(ProcessedFile.count).to eq 1
      expect(ProcessedFile.last.status).to eq "Processed"
      expect(page).to have_content 'Successfully queued spreadsheet for import'
    end
  end

  context 'when user uploads a CSV with invalid headers' do
    it "creates new ProcessedFile record with failed status" do
      visit 'file_uploads/new'

      select "Tagged Animal Assessment", from: 'category'
      attach_file('input_file', Rails.root + invalid_headers_file)
      click_on 'Submit'

      expect(ProcessedFile.count).to eq 1
      processed_file = ProcessedFile.last
      expect(processed_file.status).to eq "Failed"
      expect(processed_file.job_errors).to eq "Does not have valid headers. Data not imported!"
      expect(page).to have_content 'Successfully queued spreadsheet for import'
    end
  end

  context 'when user upload a CSV that has been already processed' do
    it "creates new ProcessedFile record with failed status" do
      ProcessedFile.create!(
        filename: '1570712512_473156000_Tagged_assessment_12172018 (original).csv',
        original_filename: 'Tagged_assessment_12172018 (original).csv',
        category: 'TaggedAnimalAssessment',
        status: 'Processed'
      )

      visit 'file_uploads/new'

      select "Tagged Animal Assessment", from: 'category'
      attach_file('input_file', Rails.root + valid_file)
      click_on 'Submit'

      expect(ProcessedFile.count).to eq 2
      processed_file = ProcessedFile.where(status: "Failed").first
      expect(processed_file.job_errors).to eq "Already processed a file with the same name. Data not imported!"
      expect(page).to have_content 'Successfully queued spreadsheet for import'
    end
  end
end