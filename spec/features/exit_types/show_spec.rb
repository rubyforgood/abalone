require 'rails_helper'

describe "When I visit the exit type Show page" do
  it "I see information of a specific exit type" do
    user = create(:user, :admin)
    exit_type = create(:exit_type, organization: user.organization)

    sign_in user

    visit exit_type_path(exit_type)

    expect(page).to have_content(exit_type.name)
    expect(page).to have_content(exit_type.disabled)
  end
end