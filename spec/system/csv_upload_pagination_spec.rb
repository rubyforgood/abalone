require 'rails_helper'

describe "pagination for file uploads page", type: :system do
  let(:user) { create(:user) }

  context "when viewing the list of file uploads" do
    it "should paginate the list" do
      Pagy::VARS[:items] = 3
      files = FactoryBot.create_list(:processed_file, 5, organization_id: user.organization_id)
      sign_in user
      visit file_uploads_path
      expect(page).to have_content(files.first.filename, count: 3)
    end

    it "should display page numbers" do
      Pagy::VARS[:items] = 3
      FactoryBot.create_list(:processed_file, 5, organization_id: user.organization_id)
      sign_in user
      visit file_uploads_path
      expect(page).to have_link("2")
    end
  end
end
