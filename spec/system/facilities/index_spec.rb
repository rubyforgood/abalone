require 'rails_helper'

describe "When I visit the facility Index page", type: :system do
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
    expect(page).to have_content("Actions")
    expect(page).to have_link("New Facility")
    expect(page).to have_link("Show")
    expect(page).to have_selector("a[aria-label='Show #{facility.name}']")
    expect(page).to have_link(nil, href: edit_facility_path(facility.id))
    expect(page).to have_selector("a[data-method='delete'][href='#{facility_path(facility.id)}']")
    expect(page).to have_selector("a[aria-label='#{facility.name} location']")

    expect(page).to have_content(facility.name)
    expect(page).to have_content(facility.code)

    within('tbody') do
      expect(page).to have_xpath('.//tr', count: facility_count)
    end
  end

  it "should allow exporting to csv" do
    facilities = create_list(:facility, 5, organization: user.organization)

    visit facilities_path

    find('#export_button').click

    expect(page.response_headers['Content-Type']).to eql "text/csv"
    expect(page).to have_content(Facility.exportable_columns.join(','))

    facilities.each { |facility| expect(page).to have_content(facility.code) }
  end

  it "should allow editing and deleting facilities" do
    facility = create(:facility, organization: user.organization)

    visit facilities_path

    expect(page).to have_selector("a[href='#{edit_facility_path(facility)}']")
    expect(page).to have_selector("a[aria-label='Edit #{facility.name}']")
    expect(page).to have_selector("a[data-method='delete'][href='#{facility_path(facility.id)}']")
    expect(page).to have_selector("a[aria-label='Delete #{facility.name}']")
  end
end
