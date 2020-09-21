require 'rails_helper'

describe "When I visit the tank Show page" do
  let(:user) { create(:user) }

  before do
    sign_in user
  end

  it "Then I see information of a specific tank" do
    tank = FactoryBot.create(:tank)

    visit tank_path(tank)

    expect(page).to have_content(tank.name)
    expect(page).to have_content(tank.facility.name)
  end
end
