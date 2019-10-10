require 'rails_helper'

describe "upload process for TaggedAnimalAssessmentJob", type: :feature do

  it "is succsess" do
    visit 'file_uploads/new'
    expect(page).to have_content 'File Uploads'
  end
end
