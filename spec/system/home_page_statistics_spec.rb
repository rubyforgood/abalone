require 'rails_helper'

describe 'Home Page Statistics', type: :system do
  describe 'view home page statistics' do
    let(:organization) { create(:organization, name: 'White Abalone') }
    let(:user) { create(:user, organization: organization) }
    let!(:animal) { create(:animal, organization: organization) }
    let!(:facility) { create(:facility, organization: organization) }
    let!(:cohort) { create(:cohort, organization: organization) }

    it 'When I view the home page as a visitor I see no data' do
      visit root_path
      expect(page).to_not have_selector('.container .shadow')
      expect(page).to have_selector('span[tabindex=1]') # Abalone Analytics link
    end

    it 'When I login and view the home page I see my company data' do
      sign_in user
      visit root_path

      expect(page.all('h1').count).to eq(1)
      expect(page.find('h1').text).to eq('Abalone Analytics')
      expect(page.find('h2').text).to eq('Your organization: White Abalone')
      expect(page.all('.container .dashboard-cards')[0].find('.text-title4').text).to eq('Total No. of Animals 1') # Total No. of Animals
      expect(page.all('.container .dashboard-cards')[1].find('.text-title4').text).to eq('Number of Facilities 1') # Number of Facilities
      expect(page.all('.container .dashboard-cards')[2].find('.text-title4').text).to eq('Number of Cohorts 1') # Number of Cohorts

      expect(page).to have_selector('span[tabindex=1]') # Abalone Analytics link
      expect(page).to have_selector('a[tabindex=2]')    # Reports link
      expect(page).to have_selector('a[tabindex=3]')    # Statistics Dropwdown
      expect(page).to have_selector('a[tabindex=4]')    # Facilities link
      expect(page).to have_selector('a[tabindex=5]')    # Enclosures link
      expect(page).to have_selector('a[tabindex=6]')    # Animals link
      expect(page).to have_selector('a[tabindex=7]')    # Cohorts link
      expect(page).to have_selector('a[tabindex=8]')    # Uploads dropdown
      expect(page).to have_selector('a[tabindex=18]')   # User dropdown

      expect(page).to_not have_selector('a[tabindex=15]') # Admin dropdown
    end

    context "as an admin" do
      let(:admin) { create(:user, :admin, organization: organization) }

      it "I can see the admin dropdown" do
        sign_in admin
        visit root_path

        expect(page).to have_selector('a[tabindex=15]') # Admin dropdown
      end
    end
  end
end
