require 'rails_helper'

describe "When I visit the family Index page" do
  let(:user) { create(:user) }

  before do
    sign_in user
  end

  it "Then I see a list of all the families" do
    family = create(:family, organization: user.organization)

    visit families_path

    expect(page).to have_content("Name")
    expect(page).to have_content("Female")
    expect(page).to have_content("Male")
    expect(page).to have_content("Tank")

    expect(page).to have_link("New Family")

    expect(page).to have_link("Show")
    expect(page).to have_link(nil, href: edit_family_path(family.id))
    expect(page).to have_selector("a[data-method='delete'][href='#{family_path(family.id)}']")
  end
end
