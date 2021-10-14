require 'rails_helper'

describe "When I visit the facility New page", type: :system do
  let(:user) { create(:user) }

  before do
    sign_in user
  end

  it "And fill out the form and click the submit button, a facility is created" do
    visit new_facility_path

    within('form') do
      fill_in 'Name', with: 'Aquarium of the Pacific'
      fill_in 'Code', with: 'AOP'
      click_on 'Submit'
    end

    expect(page).to have_content 'Facility was successfully created.'
    within('.container') do
      expect(page).to have_content 'Aquarium of the Pacific'
      expect(page).to have_content 'AOP'
    end
  end
end
