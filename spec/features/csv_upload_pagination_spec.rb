require 'rails_helper'

describe "pagination for file uploads page", type: :feature do
  let(:user) { create(:user) }

  context "When I visit Files List containing more than the default amount of items" do
    it "should paginate the list" do
      files = FactoryBot.create_list(:processed_file, 30)
      sign_in user
      visit file_uploads_path
      expect(page).to have_content(files.first.filename, count: 20)
    end
  end
end
