require 'rails_helper'

describe "When I visit the tank Upload Csv page" do
  let(:user) { create(:user) }

  before { sign_in user }

  it "Then I can upload a CSV of tanks to import" do
    facility = create(:facility, name: 'Aquarium of the Pacific', code: 'AOP', organization_id: user.organization.id)

    visit csv_upload_tanks_path

    expect(page).to have_link("Click here")
    expect(page).to have_content("Click here for a sample csv file.")
    expect(page).to have_content("Click here to view facilities codes.")

    attach_file('tank_csv', "#{Rails.root}/spec/fixtures/tanks.csv")

    click_on 'Submit'

    expect(page).to have_current_path(tanks_path)

    visit tanks_path

    within('tbody') { expect(page).to have_xpath('.//tr', count: 2) }

    # Verify no duplicates and assigned to correct org
    tanks = Tank.where(facility: facility)
    expect(tanks.count).to eql(2)
    expect(tanks.first.organization_id).to eql(user.organization.id)
  end
end
