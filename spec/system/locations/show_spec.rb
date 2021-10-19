require 'rails_helper'

describe "When I visit the location Show page" do
  let(:user) { create(:user) }

  before do
    sign_in user
  end

  it "Then I see information of a specific location" do
    facility = create(:facility)
    location = create(:location, facility: facility)
    enclosure1 = create(:enclosure, location: location)
    enclosure2 = create(:enclosure, location: location)
    enclosure3 = create(:enclosure, location: location)

    visit facility_location_path(facility, location)

    expect(page).to have_content(location.name)
    expect(page).to have_content(facility.name)
    expect(page).to have_content(enclosure1.name)
    expect(page).to have_content(enclosure2.name)
    expect(page).to have_content(enclosure3.name)
  end
end
