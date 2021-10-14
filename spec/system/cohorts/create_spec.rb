require 'rails_helper'

describe "When I visit the cohort New page", type: :system do
  let(:user) { create(:user) }

  before do
    sign_in user
  end

  it "And fill out the form and click the submit button, cohort should be created" do
    female = create(:animal, sex: :female, tag: "G888", organization_id: user.organization_id)
    male = create(:animal, sex: :male, tag: "G987", organization_id: user.organization_id)

    visit new_cohort_path

    within('form') do
      fill_in 'cohort_name', with: "Gary's cohort"
      select female.tag, from: 'cohort_female_id'
      select male.tag, from: 'cohort_male_id'
      click_on 'Submit'
    end

    expect(page).to have_content 'Cohort was successfully created.'
  end
end
