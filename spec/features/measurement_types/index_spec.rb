require 'rails_helper'

describe "When I visit the measurement_type index page" do
  let(:user) { create(:user) }

  before do
    sign_in user
  end

  it "Then I see a list of measurement_types" do
    measurement_types = FactoryBot.create_list(:measurement_type, 3, organization: user.organization)

    visit measurement_types_path

    measurement_types.each do |measurement_type|
      expect(page).to have_content(measurement_type.name)
      expect(page).to have_content(measurement_type.unit)
    end
  end
end
