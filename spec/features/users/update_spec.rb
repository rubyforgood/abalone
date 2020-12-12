require 'rails_helper'

describe "When I visit the user Edit page" do
  let(:organization) { create(:organization) }
  let(:admin) { create(:user, :admin, organization: organization) }

  before do
    sign_in admin
  end

  context "As an admin user" do
    it "Then I can update a user" do
      user = create(:user, organization: organization)

      visit edit_user_path(user)

      within('form') do
        fill_in('Email', with: "another@email.com")
        fill_in('Password', with: "anewpassword")
        click_on('Submit')
      end

      expect(page).to have_content('User was successfully updated.')
      expect(page).to have_content('another@email.com')
    end
  end
end
