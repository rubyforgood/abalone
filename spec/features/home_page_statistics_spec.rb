require 'rails_helper'

RSpec.describe 'Home Page Statistics' do
  describe 'view home page statistics', type: :feature do
    let(:user) { create(:user) }

    it 'When I view the home page as a visitor I see example data' do
      visit root_path
      expect(page.all('.card-content')[0].find('.title').text).to eq('41')
      expect(page.all('.card-content')[1].find('.title').text).to eq('3')
      expect(page.all('.card-content')[2].find('.title').text).to eq('7')
    end

    it 'When I login and view the home page I see my company data' do
      sign_in user
      visit root_path
      expect(page.all('.card-content')[0].find('.title').text).to eq('0')
      expect(page.all('.card-content')[1].find('.title').text).to eq('0')
      expect(page.all('.card-content')[2].find('.title').text).to eq('0')
    end
  end
end
