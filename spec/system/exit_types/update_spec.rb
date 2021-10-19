require 'rails_helper'

describe "When I visit the exit type Edit page", type: :system do
  let(:user) { create(:user, role: 'admin') }

  before do
    sign_in user
  end

  it "And fill out the form and click the submit button, exit_type should be updated" do
    exit_type = create(:exit_type, organization: user.organization)

    visit edit_exit_type_path(exit_type)

    within('form') do
      fill_in 'exit_type_name', with: 'new name'
      click_on 'Submit'
    end

    expect(page).to have_content 'Exit type was successfully updated.'
    within('.container') do
      expect(page).to have_content 'new name'
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

  it "I can't update an exit type of another organization" do
    exit_type = create(:exit_type)

    visit edit_exit_type_path(exit_type)

    expect(page).to have_content 'You are not authorized to access this resource.'
  end
end
