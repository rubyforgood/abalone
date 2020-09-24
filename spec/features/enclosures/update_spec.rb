require 'rails_helper'

describe "When I visit the enclosure Edit page" do
  let(:user) { create(:user) }
  let!(:facility) { create(:facility, organization_id: user.organization_id) }

  before do
    sign_in user
  end

  it "And fill out the form and click the submit button, enclosure should be updated" do
    enclosure = create(:enclosure)

    visit edit_enclosure_path(enclosure)

    within('form') do
      select(facility.name, from: 'Facility')
      fill_in 'enclosure_name', with: "Gary's old enclosure"
      click_on 'Submit'
    end

    expect(page).to have_content 'Enclosure was successfully updated.'
    expect(page).to have_content(facility.name)
    expect(page).to have_content "Gary's old enclosure"
  end
end
