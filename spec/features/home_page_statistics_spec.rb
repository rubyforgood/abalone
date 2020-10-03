require 'rails_helper'

RSpec.describe 'Home Page Statistics' do
  describe 'view home page statistics', type: :feature do
    let(:organization) { create(:organization) }
    let(:user) { create(:user, organization: organization) }
    let!(:animal) { create(:animal, organization: organization) }
    let!(:facility) { create(:facility, organization: organization) }
    let!(:cohort) { create(:cohort, organization: organization) }

    it 'When I view the home page as a visitor I see no data' do
      visit root_path
      expect(page.all('.card-content')).to be_empty
    end

    it 'When I login and view the home page I see my company data' do
      sign_in user
      visit root_path
      expect(page.all('.card-content')[0].find('.title').text).to eq('1') # Total No. of Animals
      expect(page.all('.card-content')[1].find('.title').text).to eq('1') # No. of Facilities
      expect(page.all('.card-content')[2].find('.title').text).to eq('1') # No. of Cohorts
    end
  end
end
