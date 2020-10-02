require 'rails_helper'

RSpec.describe 'Home Page Statistics' do
  describe 'view home page statistics', type: :feature do
    let(:organization) { create(:organization) }
    let(:user) { create(:user, organization: organization) }
    let(:animal) { create(:animal, organization: organization) }
    let(:facility) { create(:facility, organization: organization) }
    let(:cohort) { create(:cohort, organization: organization) }

    it 'When I view the home page as a visitor I see example data' do
      visit root_path
      expect(page.all('.card-content')[0].find('.title').text).to eq('41') # Total No. of Animals
      expect(page.all('.card-content')[1].find('.title').text).to eq('3') # No. of Facilities
      expect(page.all('.card-content')[2].find('.title').text).to eq('7') # No. of Spawn Dates
    end

    it 'When I login and view the home page I see my company data' do
      animal.reload
      facility.reload
      cohort.reload
      sign_in user
      visit root_path
      expect(page.all('.card-content')[0].find('.title').text).to eq('1')
      expect(page.all('.card-content')[1].find('.title').text).to eq('1')
      expect(page.all('.card-content')[2].find('.title').text).to eq('1')
    end
  end
end
