require 'rails_helper'

describe "When I visit the enclosure New page", type: :system do
  let(:user) { create(:user) }
  let!(:location) { create(:location, organization_id: user.organization_id) }

  before do
    sign_in user
  end

  it "Then I see the enclosure form" do
    visit new_enclosure_path

    expect(page).to have_content("New Enclosure")
    expect(page).to have_content("Location")
    expect(page).to have_content("Name")
    expect(page).to have_select("enclosure_location_id", with_options: [location.name_with_facility])
  end

  it "I can create a new enclosure" do
    visit new_enclosure_path

    select(location.name, from: 'Location')
    fill_in('Name', with: "Frank's Enclosure")
    click_button('Submit')

    expect(page).to have_content("Frank's Enclosure")
    expect(page).to have_content(location.name)
  end
end
