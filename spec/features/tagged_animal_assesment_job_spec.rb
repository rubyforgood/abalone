require 'rails_helper'

describe "upload process for TaggedAnimalAssessmentJob", type: :feature do

  let(:upload_file) { "db/sample_data_files/tagged_animal_assessment/Tagged_assessment_12172018 (original).csv" }

  it "is succsess" do
    visit 'file_uploads/new'

    select "Tagged Animal Assessment", from: 'category'
    attach_file('input_file', Rails.root + upload_file)
    click_on 'Submit'

    expect(page).to have_content 'Successfully queued spreadsheet for import'
  end
end
