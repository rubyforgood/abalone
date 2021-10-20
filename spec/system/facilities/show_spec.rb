require 'rails_helper'

describe "When I visit the facility Show page", type: :system do
  let(:user) { create(:user) }

  before do
    sign_in user
  end

  it "I see information of a specific facility" do
    facility = create(:facility, organization: user.organization)

    visit facility_path(facility)

    within('.container') do
      expect(page).to have_content facility.name
      expect(page).to have_content facility.code
    end
  end

  it "I can't see a facility of another organization" do
    facility = create(:facility)

    visit facility_path(facility)

    expect(page).to have_content("You are not authorized to access this resource.")
  end
end
