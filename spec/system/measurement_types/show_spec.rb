require 'rails_helper'

describe "When I visit the measurement_type Show page", type: :system do
  let(:user) { create(:user, role: "admin") }

  before do
    sign_in user
  end

  it "Then I see information of a specific measurement_type" do
    measurement_type = FactoryBot.create(:measurement_type, organization: user.organization)

    visit measurement_type_path(measurement_type)

    expect(page).to have_content(measurement_type.name)
    expect(page).to have_content(measurement_type.unit)
  end

  it "I can't see a measurement_type of another organization" do
    measurement_type = FactoryBot.create(:measurement_type)

    visit measurement_type_path(measurement_type)

    expect(page).to have_content("You are not authorized to access this resource.")
  end
end
