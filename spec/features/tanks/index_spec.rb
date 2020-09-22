require 'rails_helper'

describe "When I visit the tank index page" do
  let(:user) { create(:user) }

  before do
    sign_in user
  end

  it "Then I see a list of tanks" do
    tanks = FactoryBot.create_list(:tank, 3, organization: user.organization)

    visit tanks_path

    tanks.each do |tank|
      expect(page).to have_content(tank.name)
      expect(page).to have_content(tank.facility_name)
    end
  end
end
