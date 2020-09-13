require 'rails_helper'

describe "Banner for current user", type: :feature do
  let(:user) { create(:user) }
  context "is determined by the organization" do
    it "Pinto Abalone user should display the correct image" do
      pinto_org = FactoryBot.create(:organization, name: "Pinto Abalone")
      pinto_user = FactoryBot.create(:user, organization_id: pinto_org.id)
      sign_in pinto_user
      visit root_path
      expect(page).to have_css("img[src*='pinto-abalone']")
    end
    it "White Abalone user should display the correct image" do
      white_org = FactoryBot.create(:organization, name: "White Abalone")
      white_user = FactoryBot.create(:user, organization_id: white_org.id)
      sign_in white_user
      visit root_path
      expect(page).to have_css("img[src*='white-abalone']")
    end
  end
end
