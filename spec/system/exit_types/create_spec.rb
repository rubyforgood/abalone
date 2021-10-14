require 'rails_helper'

describe "When I visit the exit type New page", type: :system do
  let(:user) { create(:user, role: 'admin') }

  before do
    sign_in user
  end

  it "And fill out the form and click the submit button, exit type should be created" do
    visit new_exit_type_path

    within('form') do
      fill_in 'exit_type_name', with: "test"
      click_on 'Submit'
    end

    expect(page).to have_content 'Exit type was successfully created.'
  end

  it "And click the submit button without fill the name, an error message must be shown" do
    visit new_exit_type_path

    within('form') do
      click_on 'Submit'
    end

    expect(page).to have_content "Name can't be blank"
  end
end
