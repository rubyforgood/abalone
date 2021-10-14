require 'rails_helper'

describe "When I visit the measurement_type Edit page", type: :system do
  let(:user) { create(:user, role: "admin") }

  before do
    sign_in user
  end

  it "And fill out the form and click the submit button, measurement_type should be updated" do
    measurement_type = create(:measurement_type)

    visit edit_measurement_type_path(measurement_type)

    within('form') do
      fill_in 'measurement_type_name', with: "width"
      click_on 'Submit'
    end

    expect(page).to have_content 'Measurement Type was successfully updated.'
    expect(page).to have_content "width"
  end

  context "As a non-admin user" do
    it "Then I should not have access to the measurement types action form" do
      user.update(role: "user")

      measurement_type = create(:measurement_type)

      visit edit_measurement_type_path(measurement_type)

      expect(page).to have_content 'Not authorized'
    end
  end
end
