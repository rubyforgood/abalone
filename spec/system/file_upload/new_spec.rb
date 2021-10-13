require 'rails_helper'

describe "When I visit the File Uploads New page", type: :system do
  let!(:organization) { create(:organization) }
  let(:user) { create(:user, organization: organization) }
  let!(:measurement_type1) { create(:measurement_type, organization: organization) }
  let!(:measurement_type2) { create(:measurement_type, name: 'count', unit: 'number', organization: organization) }
  let!(:measurement_type3) { create(:measurement_type, name: 'gonad score', unit: 'number', organization: organization) }
  let!(:cohort) { create(:cohort, name: 'Test Cohort', organization: organization) }
  let(:valid_file) { "#{Rails.root}/spec/fixtures/files/basic_custom_measurement_with_spaces.csv" }

  before do
    sign_in user
  end

  it "Then I see the file upload form" do
    visit new_file_upload_path

    expect(page).to have_content("File Upload")
    expect(page).to have_content("Category")
    expect(page).to have_select("category", with_options: CsvImporter::CATEGORIES)
    expect(page).to have_content("Select up to 10 files to upload")
  end

  it "I can create a new file upload" do
    visit new_file_upload_path

    select(CsvImporter::CATEGORIES.first, from: "Category")
    upload_file("Measurement", [valid_file])

    expect(page).to have_content("Successfully queued spreadsheet for import")
    expect(page).to have_current_path(file_uploads_path)

    click_on("Upload More Files")
    expect(page).to have_current_path(new_file_upload_path)
  end

  it "I can cancel creating a file upload" do
    visit new_file_upload_path
    click_on("Cancel")
    expect(page).to have_current_path(file_uploads_path)
  end
end
