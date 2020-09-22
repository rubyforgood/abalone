require 'rails_helper'

describe "When I visit the family Edit page" do
  let(:user) { create(:user) }

  before do
    sign_in user
  end

  it "And fill out the form and click the submit button, family should be updated" do
    family = create(:family)

    visit edit_family_path(family)

    within('form') do
      fill_in 'family_name', with: "Gary's new family"
      click_on 'Submit'
    end

    expect(page).to have_content 'Family was successfully updated.'
    expect(page).to have_content "Gary's new family"
  end
end
