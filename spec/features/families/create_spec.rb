require 'rails_helper'

describe "When I visit the family New page" do
  let(:user) { create(:user) }

  before do
    sign_in user
  end

  it "And fill out the form and click the submit button, family should be created" do
    female = create(:animal, sex: 'female')
    male = create(:animal, sex: 'male', pii_tag: 2)

    visit new_family_path

    within('form') do
      fill_in 'family_name', with: "Gary's family"
      select female.pii_tag, from: 'family_female_id'
      select male.pii_tag, from: 'family_male_id'
      click_on 'Submit'
    end

    expect(page).to have_content 'Family was successfully created.'
  end
end
