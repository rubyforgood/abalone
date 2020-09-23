require 'rails_helper'

describe "When I visit the measurement_type Index page" do
  let(:user) { create(:user) }

  before do
    sign_in user
  end

  it "Then I click the delete button, measurement_type should be deleted" do
    measurement_type1 = create(:measurement_type, organization: user.organization)
    measurement_type_count = MeasurementType.for_organization(user.organization).count

    visit measurement_types_path

    link = find("a[data-method='delete'][href='#{measurement_type_path(measurement_type1.id)}']")

    within('tbody') do
      expect(page).to have_xpath('.//tr', count: measurement_type_count)
      link.click
      expect(page).to have_xpath('.//tr', count: (measurement_type_count - 1))
    end
  end
end
