require 'rails_helper'

describe "When I visit the exit type index page", type: :system do
  let(:user) { create(:user, role: "admin") }

  before do
    sign_in user
  end

  it "Then I see a list of exit_types" do
    exit_types = FactoryBot.create_list(:exit_type, 3, organization: user.organization)

    visit exit_types_path

    exit_types.each do |exit_type|
      expect(page).to have_content(exit_type.name)
    end
  end

  it "Then I can't see exit_types of another organization" do
    exit_type = FactoryBot.create(:exit_type)

    visit exit_types_path

    expect(page).not_to have_content(exit_type.name)
  end

  context "As a non-admin user" do
    it "Then I should not have access to the exit types index page" do
      user.update(role: "user")

      visit exit_types_path

      expect(page).to have_content 'Not authorized'
    end
  end
end
