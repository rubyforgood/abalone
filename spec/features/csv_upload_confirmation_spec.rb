require 'rails_helper'

describe "file confirm queue page", type: :feature do
  let(:user) { create(:user) }
  let(:valid_file) { "#{Rails.root}/db/sample_data_files/tagged_animal_assessment/Tagged_assessment_12172018(original).csv" }

  context "after uploading a file" do
    it "should have a link to view all files" do
      sign_in user
      visit new_file_upload_path
      upload_file("Tagged Animal Assessment", [valid_file])
      click_link('View All Files')
      expect(page).to have_current_path(file_uploads_path)
    end
  end
end
