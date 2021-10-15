require 'rails_helper'

describe "When I visit the facility Index page", type: :system do
  let(:user) { create(:user) }

  before do
    sign_in user
  end

  it "Then I click the delete button, the facility is deleted" do
    facility = create(:facility, organization: user.organization)
    facility_count = Facility.for_organization(user.organization).count

    visit facilities_path

    link = find("a[data-method='delete'][href='#{facility_path(facility.id)}']")

    within('tbody') do
      expect(page).to have_xpath('.//tr', count: facility_count)
      link.click
      expect(page).to have_xpath('.//tr', count: (facility_count - 1))
    end
  end
end
