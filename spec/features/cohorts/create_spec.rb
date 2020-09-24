require 'rails_helper'

describe "When I visit the cohort New page" do
  let(:user) { create(:user) }

  before do
    sign_in user
  end

  it "And fill out the form and click the submit button, cohort should be created" do
    female = create(:animal, sex: :female, organization_id: user.organization_id)
    male = create(:animal, sex: :male, pii_tag: 2, organization_id: user.organization_id)

    visit new_cohort_path

    within('form') do
      fill_in 'cohort_name', with: "Gary's cohort"
      select female.pii_tag, from: 'cohort_female_id'
      select male.pii_tag, from: 'cohort_male_id'
      click_on 'Submit'
    end

    expect(page).to have_content 'Cohort was successfully created.'
  end
end
