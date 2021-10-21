require 'rails_helper'

describe "When I visit the exit type Show page", type: :system do
  it "I see information of a specific exit type" do
    user = create(:user, :admin)
    exit_type = create(:exit_type, name: "test", organization: user.organization)

    sign_in user

    visit exit_type_path(exit_type)

    expect(page).to have_content(exit_type.name)
  end

  it "I can't see an exit type of another organization" do
    user = create(:user, :admin)
    exit_type = create(:exit_type, name: "test")

    sign_in user

    visit exit_type_path(exit_type)

    expect(page).to have_content("You are not authorized to access this resource.")
  end
end
