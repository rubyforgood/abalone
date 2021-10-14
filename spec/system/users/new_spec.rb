require 'rails_helper'

describe "When I visit the User New page", type: :system do
  let(:user) { create(:user, :admin) }

  before do
    sign_in user
  end

  context "As an admin user" do
    it "Then I see a user form" do
      visit new_user_path

      expect(page).to have_content("New User")
      expect(page).to have_content("Email")
      expect(page).to have_content("Password")
      expect(page).to have_select("user_role", with_options: %w[user admin])
    end

    it "I can create a new user" do
      visit new_user_path

      fill_in("Email", with: "test@example.com")
      fill_in("Password", with: "password")
      select("user", from: 'Role')
      click_button('Submit')

      expect(page).to have_content("test@example.com")
      expect(page).to have_content(user.organization.name)
    end
  end

  context "As a non-admin user" do
    it "Then I should not have access to the user form" do
      user.update(role: "user")

      visit new_user_path

      expect(page).to have_content 'Not authorized'
    end
  end
end
