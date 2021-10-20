require 'rails_helper'

describe "upload Measurement category", type: :system do
  include Devise::Test::IntegrationHelpers

  let(:user) { create(:user) }

  before do
    sign_in user
  end

  context 'when user file is not successfully uploaded' do
    it "user can removes the failed upload if it belong to the current organization" do
      FactoryBot.create(:processed_file, status: "Failed", organization: user.organization)
      visit file_uploads_path
      click_on 'Remove upload'
      expect(page).to have_content('File successfully deleted')
    end
  end
end
