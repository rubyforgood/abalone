require 'rails_helper'

describe "When I visit the enclosure Index page", type: :system do
  let(:user) { create(:user) }

  before do
    sign_in user
  end

  it "Then I click the delete button, enclosure should be deleted" do
    enclosure1 = create(:enclosure, organization: user.organization)
    enclosure_count = Enclosure.for_organization(user.organization).count

    visit enclosures_path

    link = find("a[data-method='delete'][href='#{enclosure_path(enclosure1.id)}']")

    within('tbody') do
      expect(page).to have_xpath('.//tr', count: enclosure_count)
      link.click
      expect(page).to have_xpath('.//tr', count: (enclosure_count - 1))
    end
  end
end
