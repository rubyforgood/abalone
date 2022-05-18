require 'rails_helper'

describe 'When I visit the Measurements page', type: :system do
  let(:organization2) { create(:organization, name: 'Black Abalone') }
  let(:user) { create(:user, organization: organization) }
  let!(:measurement2) { create(:measurement, organization: organization2, value: organization2.id) }
  let(:organization) { create(:organization, name: 'White Abalone') }
  let!(:measurements) { create_list(:measurement, 3, organization: user.organization, value: organization.id) }

  before do
    sign_in user
    visit measurements_path
  end

  it 'Displays measurements for current organizations', :aggregate_failures do
    within('tbody') do
      expect(page).to have_xpath('.//tr', count: measurements.count)
      expect(page).to have_content organization.id
    end
  end

  it 'Then will not display second organization measurement' do
    within('tbody') do
      expect(page).not_to have_content organization2.id
    end
  end
end
