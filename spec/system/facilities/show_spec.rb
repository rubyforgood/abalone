require 'rails_helper'

describe "When I visit the facility Show page", type: :system do
  let(:user) { create(:user) }

  before do
    sign_in user
  end

  it "I see information of a specific facility" do
    facility = create(:facility)

    visit facility_path(facility)

    within('.container') do
      expect(page).to have_content facility.name
      expect(page).to have_content facility.code
    end
  end
end
