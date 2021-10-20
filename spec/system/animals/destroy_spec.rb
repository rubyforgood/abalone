require 'rails_helper'

describe "When I visit the animal Index page", type: :system do
  let(:user) { create(:user) }

  before do
    sign_in user
  end

  it "Then I click the delete button, animal should be deleted" do
    animal1 = create(:animal, entry_year: 2, tag: "G123", organization: user.organization)
    animal_count = Animal.for_organization(user.organization).count

    visit animals_path

    link = find("a[data-method='delete'][href='#{animal_path(animal1.id)}']")

    within('tbody') do
      expect(page).to have_xpath('.//tr', count: animal_count)
      link.click
      expect(page).to have_xpath('.//tr', count: (animal_count - 1))
    end
  end
end
