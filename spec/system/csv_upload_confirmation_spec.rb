require 'rails_helper'

describe "file confirm queue page", type: :system do
  let(:user) { create(:user) }
  let(:valid_file) { "#{Rails.root}/db/sample_data_files/measurement/basic_measurement.csv" }

  context "after uploading a file" do
    it "should have a link to view all files" do
      sign_in user
      visit new_file_upload_path
      upload_file("Measurement", [valid_file])
      click_link('View All Files')
      expect(page).to have_current_path(file_uploads_path)
    end
  end
end
