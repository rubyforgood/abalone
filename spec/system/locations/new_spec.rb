require 'rails_helper'

describe "When I visit the location New page", type: :system do
  let(:user) { create(:user) }
  let!(:facility) { create(:facility, organization_id: user.organization_id) }

  before do
    sign_in user
  end

  it "Then I see the location form" do
    visit new_facility_location_path(facility)

    expect(page).to have_content("New Location")
    expect(page).to have_content("Name")
  end

  it "I can create a new location" do
    visit new_facility_location_path(facility)

    fill_in('Name', with: "Secret location")
    click_button('Submit')

    expect(page).to have_content("Secret location")
  end
end
