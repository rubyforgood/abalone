require 'rails_helper'

describe "When I visit the animal Index page" do
  let(:user) { create(:user) }

  before do
    sign_in user
  end

  it "Then I click the delete button, animal should be deleted" do
    animal1 = FactoryBot.create(:animal, collection_year: 2, tag_id: 2, pii_tag: 1234)
    animal_count = Animal.count

    visit animals_path

    link = find("a[data-method='delete'][href='#{animal_path(animal1.id)}']")

    within('tbody') do
      expect(page).to have_xpath('.//tr', count: animal_count)
      link.click
      expect(page).to have_xpath('.//tr', count: (animal_count - 1))
    end
  end
end
