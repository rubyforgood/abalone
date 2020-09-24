require 'rails_helper'

describe "When I visit the animal New page" do
  let(:user) { create(:user) }

  before do
    sign_in user
  end

  it "And fill out the form and click the submit button, animal should be created" do
    cohort = create(:cohort, organization: user.organization)

    visit new_animal_path

    within('form') do
      fill_in 'animal_pii_tag', with: "An Animal"
      select "Male", from: 'animal_sex'
      select cohort.name, from: 'animal_cohort_id'
      fill_in 'animal_shl_numbers_codes', with: "c123,k123-32"
      click_on 'Submit'
    end

    expect(page).to have_content 'Animal was successfully created.'
  end
end
