require 'rails_helper'

describe "When I visit the locations index page", type: :system do
  let(:user) { create(:user) }

  before do
    sign_in user
  end

  it "Then I see a list of locations" do
    facility = create(:facility)
    locations = create_list(:location, 3, facility: facility, organization: user.organization)

    visit facility_locations_path(facility)

    locations.each do |location|
      expect(page).to have_content(location.name)
      expect(page).to have_content(location.facility_name)
    end
  end
end
