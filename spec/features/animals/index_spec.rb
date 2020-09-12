require 'rails_helper'

describe "When I visit the animal Index page" do
  let(:user) { create(:user) }

  before do
    sign_in user
  end

  it "Then I see a list of all the animals" do
    animal = FactoryBot.create(:animal, collection_year: 2, tag_id: 2)
    animal_count = Animal.count

    visit animals_path

    expect(page).to have_content("Collection Year")
    expect(page).to have_content("Tag ID")
    expect(page).to have_link("New Animal")
    expect(page).to have_link("Show")
    expect(page).to have_link(nil, :href => edit_animal_path(animal.id))
    expect(page).to have_selector("a[data-method='delete'][href='#{animal_path(animal.id)}']")

    expect(page).to have_content(animal.collection_year)
    expect(page).to have_content(animal.tag_id)

    within('tbody') do
      expect(page).to have_xpath('.//tr', :count => animal_count)
    end


  end

end
