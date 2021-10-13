require 'rails_helper'

describe "When I visit the location Edit page", type: :system do
  let(:user) { create(:user) }
  let!(:facility) { create(:facility, organization_id: user.organization_id) }

  before do
    sign_in user
  end

  it "And fill out the form and click the submit button, location should be updated" do
    location = create(:location, facility: facility)

    visit edit_facility_location_path(facility, location)

    within('form') do
      fill_in 'location_name', with: "Public location"
      click_on 'Submit'
    end

    expect(page).to have_content 'Location was successfully updated.'
    expect(page).to have_content "Public location"
  end
end
