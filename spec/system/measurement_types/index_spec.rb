require 'rails_helper'

describe "When I visit the measurement_type index page", type: :system do
  let(:user) { create(:user, role: "admin") }
  let!(:measurement_types) { FactoryBot.create_list(:measurement_type, 3, organization: user.organization) }

  before do
    sign_in user
  end

  it "Then I see a list of measurement_types" do
    visit measurement_types_path

    measurement_types.each do |measurement_type|
      expect(page).to have_content(measurement_type.name)
      expect(page).to have_content(measurement_type.unit)
    end
  end

  context "As a non-admin user" do
    before do
      user.update(role: "user")
    end

    it "Then I should not have access to the measurement types index page" do
      visit measurement_types_path
      expect(page).to have_content 'Not authorized'
    end
  end

  context "with measurement_types with dependent measurements" do
    before do
      measurement_types.each { |measurement_type| create(:measurement, measurement_type: measurement_type) }
    end

    it "does not display option to delete that measurement_type" do
      visit measurement_types_path
      expect(page).not_to have_css(".trash-icon")
    end
  end
end
