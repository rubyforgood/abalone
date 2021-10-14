require 'rails_helper'

describe "upload Measurement category", type: :system do
  include Devise::Test::IntegrationHelpers

  let(:user) { create(:user) }

  before do
    sign_in user
  end

  context 'when user file is not successfully uploaded' do
    it "user removes the failed upload" do
      FactoryBot.create(:processed_file, status: "Failed")
      visit file_uploads_path
      click_on 'Remove upload'
      expect(page).to have_content('File successfully deleted')
    end
  end
end
