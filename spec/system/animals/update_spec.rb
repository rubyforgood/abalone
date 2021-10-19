require 'rails_helper'

describe "When I visit the animal Edit page", type: :system do
  let(:user) { create(:user) }

  before do
    sign_in user
  end

  it "And fill out the form and click the submit button, animal should be updated" do
    animal = create(:animal, organization: user.organization)
    cohort = create(:cohort, organization: user.organization)

    visit edit_animal_path(animal)

    within('form') do
      fill_in 'animal_entry_year', with: '2020'
      fill_in 'animal_entry_date', with: '1/1/2020'
      fill_in 'animal_tag', with: 'Y200'
      select "Male", from: 'animal_sex'
      select cohort.name, from: 'animal_cohort_id'
      fill_in 'animal_shl_numbers_codes', with: 'c123, k123-32'
      click_on 'Submit'
    end

    expect(page).to have_content 'Animal was successfully updated.'
    within('.container') do
      expect(page).to have_content '2020'
      expect(page).to have_content '2020-01-01 00:00:00 UTC'
      expect(page).to have_content 'Y200'
      expect(page).to have_content 'Male'
      expect(page).to have_content cohort.name
      expect(page).to have_content 'c123, k123-32'
    end
  end

  it "I can't update an animal of another organization" do
    animal = create(:animal)

    visit edit_animal_path(animal)

    expect(page).to have_content 'You are not authorized to access this resource.'
  end
end
