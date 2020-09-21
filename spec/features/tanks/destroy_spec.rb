require 'rails_helper'

describe "When I visit the tank Index page" do
  let(:user) { create(:user) }

  before do
    sign_in user
  end

  it "Then I click the delete button, tank should be deleted" do
    tank1 = create(:tank)
    tank_count = Tank.count

    visit tanks_path

    link = find("a[data-method='delete'][href='#{tank_path(tank1.id)}']")

    within('tbody') do
      expect(page).to have_xpath('.//tr', count: tank_count)
      link.click
      expect(page).to have_xpath('.//tr', count: (tank_count - 1))
    end
  end
end
