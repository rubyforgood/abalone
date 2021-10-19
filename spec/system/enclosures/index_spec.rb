require 'rails_helper'

describe "When I visit the enclosure index page", type: :system do
  let(:user) { create(:user) }

  before do
    sign_in user
  end

  it "Then I see a list of enclosures" do
    enclosures = create_list(:enclosure, 3, organization: user.organization)

    visit enclosures_path

    expect(page).to have_content("Name")
    expect(page).to have_content("Facility")
    expect(page).to have_content("Location")
    expect(page).to have_content("Actions")

    enclosures.each do |enclosure|
      expect(page).to have_content(enclosure.name)
      expect(page).to have_content(enclosure.facility_name)
      expect(page).to have_content(enclosure.location_name)
      expect(page).to have_link('Show')
      expect(page).to have_selector("a[aria-label='Show #{enclosure.name}']")
    end
  end

  it "should allow exporting to csv" do
    skip
    enclosures = create_list(:enclosure, 5, organization: user.organization)

    visit enclosures_path

    click_on "Export to CSV"

    expect(page.response_headers['Content-Type']).to eql "text/csv"
    expect(page).to have_content(Enclosure.exportable_columns.join(','))

    enclosures.each { |enclosure| expect(page).to have_content(enclosure.name) }
  end
end
