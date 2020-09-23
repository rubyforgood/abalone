require 'rails_helper'

describe "When I visit the user index page" do
  let(:organization) { create(:organization) }
  let(:user) { create(:user, organization: organization) }

  before do
    sign_in user
  end

  it "As a non-admin user, I shouldn't have access to the users index page for my organization" do
    visit users_path

    expect(page).to have_content 'Not authorized'
  end

  it "As an admin user, I should have access to the users index page for my organization" do
    user.update(role: 'admin')

    users = FactoryBot.create_list(:user, 3, organization: organization)

    visit users_path

    expect(page).to have_content 'Users'

    users.each do |user|
      expect(page).to have_content user.email
      expect(page).to have_content user.role
      expect(page).to have_content user.organization.name
    end
  end

  it "As an admin user, I should not see users that belong to a different organization than me" do
    user.update(role: 'admin')

    other_organization = create(:organization)
    users = FactoryBot.create_list(:user, 3, organization: other_organization)

    visit users_path

    expect(page).to have_content 'Users'

    users.each do |user|
      expect(page).to_not have_content user.email
      expect(page).to_not have_content user.role
      expect(page).to_not have_content user.organization.name
    end
  end
end
