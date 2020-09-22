require 'rails_helper'

describe "When I visit the tank Edit page" do
  let(:user) { create(:user) }
  let!(:facility) { create(:facility, organization_id: user.organization_id) }

  before do
    sign_in user
  end

  it "And fill out the form and click the submit button, tank should be updated" do
    tank = create(:tank)

    visit edit_tank_path(tank)

    within('form') do
      select(facility.name, from: 'Facility')
      fill_in 'tank_name', with: "Gary's old tank"
      click_on 'Submit'
    end

    expect(page).to have_content 'Tank was successfully updated.'
    expect(page).to have_content(facility.name)
    expect(page).to have_content "Gary's old tank"
  end
end
