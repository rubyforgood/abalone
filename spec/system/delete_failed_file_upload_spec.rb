require 'rails_helper'

describe "upload Measurement category", type: :system do
  include Devise::Test::IntegrationHelpers

  let(:user) { create(:user) }

  before do
    sign_in user
  end

  context 'when user file is not successfully uploaded' do
    it "user can removes the failed upload if it belong to the current organization" do
      processed_file = create(:processed_file, status: "Failed", organization: user.organization)
      processed_files_count = ProcessedFile.for_organization(user.organization).count

      visit file_uploads_path

      link = find("a[data-method='delete'][href='#{file_upload_path(processed_file.id)}']")
      within('tbody') do
        expect(page).to have_xpath('.//tr', count: processed_files_count)
        link.click
        expect(page).to have_xpath('.//tr', count: (processed_files_count - 1))
      end
    end
  end
end
