require 'rails_helper'

describe "When I visit the family Index page" do
  let(:user) { create(:user) }

  before do
    sign_in user
  end

  it "Then I click the delete button, family should be deleted" do
    family1 = create(:family, organization: user.organization)
    family_count = Family.for_organization(user.organization).count

    visit families_path

    link = find("a[data-method='delete'][href='#{family_path(family1.id)}']")

    within('tbody') do
      expect(page).to have_xpath('.//tr', count: family_count)
      link.click
      expect(page).to have_xpath('.//tr', count: (family_count - 1))
    end
  end
end
