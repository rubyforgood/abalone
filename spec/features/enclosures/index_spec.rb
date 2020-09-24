require 'rails_helper'

describe "When I visit the enclosure index page" do
  let(:user) { create(:user) }

  before do
    sign_in user
  end

  it "Then I see a list of enclosures" do
    enclosures = FactoryBot.create_list(:enclosure, 3, organization: user.organization)

    visit enclosures_path

    enclosures.each do |enclosure|
      expect(page).to have_content(enclosure.name)
      expect(page).to have_content(enclosure.facility_name)
    end
  end
end
