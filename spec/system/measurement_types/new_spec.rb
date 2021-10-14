require 'rails_helper'

describe "When I visit the measurement_type New page", type: :system do
  let(:user) { create(:user, role: "admin") }

  before do
    sign_in user
  end

  it "Then I see the measurement_type form" do
    visit new_measurement_type_path

    expect(page).to have_content("New Measurement Type")
    expect(page).to have_content("Name")
    expect(page).to have_content("Unit")
  end

  it "I can create a new measurement_type" do
    visit new_measurement_type_path

    fill_in('Name', with: "Length")
    fill_in('Unit', with: "cm")
    click_button('Submit')

    expect(page).to have_content("Length")
    expect(page).to have_content("cm")
  end

  context "As a non-admin user" do
    it "Then I should not have access to the measurement types action form" do
      user.update(role: "user")

      visit new_measurement_type_path

      expect(page).to have_content 'Not authorized'
    end
  end
end
