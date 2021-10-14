require 'rails_helper'

describe "When I visit the enclosure Upload Csv page", type: :system do
  let(:user) { create(:user) }

  before { sign_in user }

  it "Then I can upload a CSV of enclosures to import" do
    facility = create(:facility, name: 'Aquarium of the Pacific', code: 'AOP', organization: user.organization)
    location = create(:location, facility: facility, name: 'SeaLab2020', organization: user.organization)
    location2 = create(:location, facility: facility, name: 'Atlantis', organization: user.organization)

    visit csv_upload_enclosures_path

    expect(page).to have_link("Click here")
    expect(page).to have_content("Click here for a sample csv file.")
    expect(page).to have_content("Click here to view facilities codes and location names.")

    attach_file('enclosure_csv', "#{Rails.root}/spec/fixtures/files/enclosures.csv")

    click_on 'Submit'

    expect(page).to have_current_path(enclosures_path)

    visit enclosures_path

    within('tbody') { expect(page).to have_xpath('.//tr', count: 2) }

    # Verify no duplicates and assigned to correct org
    enclosures = Enclosure.where(location: [location, location2])
    expect(enclosures.count).to eql(2)
    expect(enclosures.first.organization_id).to eql(user.organization.id)
  end
end
