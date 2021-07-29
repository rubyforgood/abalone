require 'rails_helper'

describe "When I visit the cohort Show page" do
  let(:user) { create(:user) }

  before do
    sign_in user
  end

  it "Then I see information of a specific cohort" do
    cohort = create(:cohort)
    enclosure = create(:enclosure)

    cohort.enclosure = enclosure
    cohort.save

    visit cohort_path(cohort)

    within('.container') do
      expect(page).to have_content cohort.name
      expect(page).to have_content cohort.female_tag
      expect(page).to have_content cohort.male_tag
      expect(page).to have_content cohort.enclosure.name
    end
  end
end
