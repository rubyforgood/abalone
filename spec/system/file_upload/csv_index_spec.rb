require 'rails_helper'

describe "When I visit the file upload index page", type: :system do
  let(:user) { create(:user) }
  let(:organization) { create(:organization) }

  before { sign_in user }

  it "Then I see a list of file uploads" do
    uploads = create_list(:file_upload, 3, organization: user.organization)

    visit csv_index_path

    within('tbody') do
      expect(page).to have_xpath('.//tr', count: 3)
    end

    uploads.each do |upload|
      expect(page).to have_content(upload.user.email)
      expect(page).to have_content(upload.file.filename)
      expect(page).to have_content(upload.status)
    end
  end

  it "Then I see a list of file uploads of my organization only" do
    uploads = create_list(:file_upload, 3, organization: user.organization)
    create_list(:file_upload, 3, organization: organization)

    visit csv_index_path

    within('tbody') do
      expect(page).to have_xpath('.//tr', count: 3)
    end

    uploads.each do |upload|
      expect(page).to have_content(upload.user.email)
      expect(page).to have_content(upload.file.filename)
      expect(page).to have_content(upload.status)
    end
  end
end
