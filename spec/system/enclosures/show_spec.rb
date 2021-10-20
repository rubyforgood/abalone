require 'rails_helper'

describe "When I visit the enclosure Show page", type: :system do
  let(:user) { create(:user) }

  before do
    sign_in user
  end

  it "Then I see information of a specific enclosure" do
    enclosure = FactoryBot.create(:enclosure, organization: user.organization)

    visit enclosure_path(enclosure)

    expect(page).to have_content(enclosure.name)
    expect(page).to have_content(enclosure.location.name)
  end

  it "I can't see an enclosure of another organization" do
    enclosure = FactoryBot.create(:enclosure)

    visit enclosure_path(enclosure)

    expect(page).to have_content("You are not authorized to access this resource.")
  end
end
