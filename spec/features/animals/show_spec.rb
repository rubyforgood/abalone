require 'rails_helper'

describe "When I visit the animal Show page" do
  it "I see information of a specific animal" do
    user = create(:user, :admin)
    cohort = create(:cohort)
    animal = create(:animal, cohort: cohort)

    sign_in user

    visit animal_path(animal)

    expect(page).to have_content(animal.entry_year)
    expect(page).to have_content(animal.entered_at)
    expect(page).to have_content(animal.entry_point)
    expect(page).to have_content(animal.tag)
    expect(page).to have_content(animal.sex.titleize)
    expect(page).to have_content(animal.cohort.name)
  end
end
