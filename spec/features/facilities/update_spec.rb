require 'rails_helper'

describe "When I visit the facility Edit page" do
  let(:user) { create(:user) }

  before do
    sign_in user
  end

  it "And fill out the form and click the submit button, the facility is updated" do
    facility = create(:facility)

    visit edit_facility_path(facility)

    within('form') do
      fill_in 'facility_name', with: 'Aquarium of the Pacific'
      fill_in 'facility_code', with: 'AOP'
      click_on 'Submit'
    end

    expect(page).to have_content 'Facility was successfully updated.'
    within('.container') do
      expect(page).to have_content 'Aquarium of the Pacific'
      expect(page).to have_content 'AOP'
    end
  end
end
