require 'rails_helper'

describe "When I visit the measurement_type index page", type: :system do
  let(:user) { create(:user, role: "admin") }

  before do
    sign_in user
  end

  it "Then I see a list of measurement_types" do
    measurement_types = FactoryBot.create_list(:measurement_type, 3, organization: user.organization)

    visit measurement_types_path

    measurement_types.each do |measurement_type|
      expect(page).to have_content(measurement_type.name)
      expect(page).to have_content(measurement_type.unit)
    end
  end

  context "As a non-admin user" do
    it "Then I should not have access to the measurement types index page" do
      user.update(role: "user")

      visit measurement_types_path

      expect(page).to have_content 'Not authorized'
    end
  end
end
