require 'rails_helper'

describe "When I visit the tank New page" do
  let(:user) { create(:user) }
  let!(:facility) { create(:facility, organization_id: user.organization_id) }

  before do
    sign_in user
  end

  it "Then I see the tank form" do
    visit new_tank_path

    expect(page).to have_content("New Tank")
    expect(page).to have_content("Facility")
    expect(page).to have_content("Name")
    expect(page).to have_select("tank_facility_id", with_options: [facility.name])
  end

  it "I can create a new tank" do
    visit new_tank_path

    select(facility.name, from: 'Facility')
    fill_in('Name', with: "Frank's Tank")
    click_button('Submit')

    expect(page).to have_content("Frank's Tank")
    expect(page).to have_content(facility.name)
  end
end
