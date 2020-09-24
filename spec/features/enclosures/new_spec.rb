require 'rails_helper'

describe "When I visit the enclosure New page" do
  let(:user) { create(:user) }
  let!(:facility) { create(:facility, organization_id: user.organization_id) }

  before do
    sign_in user
  end

  it "Then I see the enclosure form" do
    visit new_enclosure_path

    expect(page).to have_content("New Enclosure")
    expect(page).to have_content("Facility")
    expect(page).to have_content("Name")
    expect(page).to have_select("enclosure_facility_id", with_options: [facility.name])
  end

  it "I can create a new enclosure" do
    visit new_enclosure_path

    select(facility.name, from: 'Facility')
    fill_in('Name', with: "Frank's Enclosure")
    click_button('Submit')

    expect(page).to have_content("Frank's Enclosure")
    expect(page).to have_content(facility.name)
  end
end
