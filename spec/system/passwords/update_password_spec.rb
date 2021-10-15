require 'rails_helper'

describe "When I visit the user Change password page", type: :system do
  let(:user) { create(:user) }

  before do
    sign_in user
  end

  context "As an regular user" do
    it "Then I can update my own the password" do
      visit edit_password_path(user)

      within('form') do
        fill_in('Password', with: "anewpassword")
        click_on('Submit')
      end

      expect(page).to have_content('Password was successfully updated.')
    end

    it "Then I should not authorized to change other user password" do
      another_user = create(:user)

      visit edit_password_path(another_user)

      expect(page).to have_content('Not authorized')
    end
  end
end
