require 'rails_helper'

describe "When I visit the users Index page", type: :system do
  let(:organization) { create(:organization) }
  let(:user) { create(:user, :admin, organization: organization) }

  before do
    sign_in user
  end

  it "Then I click the delete button, user should be deleted" do
    user1 = create(:user, organization: user.organization)

    visit users_path

    link = find("a[data-method='delete'][href='#{user_path(user1.id)}']")
    within('tbody') do
      expect do
        link.click
      end.to change { page.all(:xpath, './/tr').count }.by(-1)
    end
  end

  it "Then I cannot delete myself" do
    create(:user, organization: user.organization)
    users_count = User.for_organization(user.organization).count

    visit users_path

    within('tbody') do
      expect(page).to have_xpath('.//tr', count: users_count)
      expect(page).not_to have_selector("a[data-method='delete'][href='#{user_path(user.id)}']")
    end
  end
end
