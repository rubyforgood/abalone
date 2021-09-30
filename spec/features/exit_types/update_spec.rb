require 'rails_helper'

describe "When I visit the exit type Edit page" do
  let(:user) { create(:user, role: 'admin') }

  before do
    sign_in user
  end

  it "And fill out the form and click the submit button, exit_type should be updated" do
    exit_type = create(:exit_type, organization: user.organization)

    visit edit_exit_type_path(exit_type)

    within('form') do
      fill_in 'exit_type_name', with: 'new name'
      check 'exit_type_disabled'
      click_on 'Submit'
    end

    expect(page).to have_content 'Exit type was successfully updated.'
    within('.container') do
      expect(page).to have_content 'new name'
      expect(page).to have_content 'true'
    end
  end

  it "And click the submit button with an empty name, an error message must be shown" do
    exit_type = create(:exit_type, organization: user.organization)

    visit edit_exit_type_path(exit_type)

    within('form') do
      fill_in 'exit_type_name', with: ''
      click_on 'Submit'
    end

    expect(page).to have_content "Name can't be blank"
  end
end
