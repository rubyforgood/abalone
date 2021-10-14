require 'rails_helper'

describe "When I visit the location Index page", type: :system do
  let(:user) { create(:user) }

  before do
    sign_in user
  end

  it "Then I click the delete button, location should be deleted" do
    facility = create(:facility, organization: user.organization)
    location = create(:location, facility: facility, organization: user.organization)
    location_count = Location.for_organization(user.organization).count

    visit facility_locations_path(facility)

    link = find("a[data-method='delete'][href='#{facility_location_path(facility, location)}']")

    within('tbody') do
      expect(page).to have_xpath('.//tr', count: location_count)
      link.click
      expect(page).to have_xpath('.//tr', count: (location_count - 1))
    end
  end
end
