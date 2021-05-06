require 'rails_helper'

RSpec.describe 'Home Page Statistics' do
  describe 'view home page statistics', type: :feature do
    let(:organization) { create(:organization, name: 'White Abalone') }
    let(:user) { create(:user, organization: organization) }
    let!(:animal) { create(:animal, organization: organization) }
    let!(:facility) { create(:facility, organization: organization) }
    let!(:cohort) { create(:cohort, organization: organization) }

    it 'When I view the home page as a visitor I see no data' do
      visit root_path
      expect(page.all('.card-content')).to be_empty
      expect(page).to have_selector('span[tabindex=1]') # Abalone Analytics link
      expect(page).to have_selector('a[tabindex=16]')   # More dropdown
    end

    it 'When I login and view the home page I see my company data' do
      sign_in user
      visit root_path

      expect(page.all('h1').count).to eq(1)
      expect(page.find('h1').text).to eq('Abalone Analytics')
      expect(page.find('h2').text).to eq('Your organization: White Abalone')
      expect(page.all('.card-content')[0].find('.title').text).to eq('1') # Total No. of Animals
      expect(page.all('.card-content')[1].find('.title').text).to eq('1') # No. of Facilities
      expect(page.all('.card-content')[2].find('.title').text).to eq('1') # No. of Cohorts

      expect(page).to have_selector('span[tabindex=1]') # Abalone Analytics link
      expect(page).to have_selector('a[tabindex=2]')    # Reports link
      expect(page).to have_selector('a[tabindex=3]')    # Facilities link
      expect(page).to have_selector('a[tabindex=4]')    # Enclosures link
      expect(page).to have_selector('a[tabindex=5]')    # Animals link
      expect(page).to have_selector('a[tabindex=6]')    # Cohorts link
      expect(page).to have_selector('a[tabindex=7]')    # Operations link
      expect(page).to have_selector('a[tabindex=8]')    # Uploads dropdown
      expect(page).to have_selector('a[tabindex=16]')   # More dropdown

      expect(page).to_not have_selector('a[tabindex=13]') # Admin dropdown
    end

    context "as an admin" do
      let(:admin) { create(:user, :admin, organization: organization) }

      it "I can see the admin dropdown" do
        sign_in admin
        visit root_path

        expect(page).to have_selector('a[tabindex=13]') # Admin dropdown
      end
    end
  end
end
