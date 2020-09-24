require 'rails_helper'

describe "When I visit the facility Index page" do
  let(:user) { create(:user) }

  before do
    sign_in user
  end

  it "Then I see a list of all the facilities" do
    facility = create(:facility, organization: user.organization)
    facility_count = Facility.for_organization(user.organization).count

    visit facilities_path

    expect(page).to have_content("Name")
    expect(page).to have_content("Code")
    expect(page).to have_link("New Facility")
    expect(page).to have_link("Show")
    expect(page).to have_link(nil, href: edit_facility_path(facility.id))
    expect(page).to have_selector("a[data-method='delete'][href='#{facility_path(facility.id)}']")

    expect(page).to have_content(facility.name)
    expect(page).to have_content(facility.code)

    within('tbody') do
      expect(page).to have_xpath('.//tr', count: facility_count)
    end
  end

  it "should allow exporting to csv" do
    facilities = create_list(:facility, 5, organization: user.organization)

    visit facilities_path

    click_on "Export to CSV"

    expect(page.response_headers['Content-Type']).to eql "text/csv"
    expect(page).to have_content(Facility.exportable_columns.join(','))

    facilities.each { |facility| expect(page).to have_content(facility.code) }
  end
end
