require 'rails_helper'

describe "When I visit the animal Show page" do
  it "I see information of a specific animal" do
    user = create(:user, role: "admin")
    animal = create(:animal)

    sign_in user

    visit animal_path(animal)

    expect(page).to have_content(animal.collection_year)
    expect(page).to have_content(animal.date_time_collected)
    expect(page).to have_content(animal.collection_position)
    expect(page).to have_content(animal.pii_tag)
    expect(page).to have_content(animal.tag_id)
    expect(page).to have_content(animal.sex.titleize)
    expect(page).to have_content(animal.cohort.name)
  end
end
