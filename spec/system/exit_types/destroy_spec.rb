require 'rails_helper'

describe "When I visit the exit type Index page", type: :system do
  let(:user) { create(:user, role: 'admin') }

  before do
    sign_in user
  end

  it "Then I click the delete button, exit type should be deleted" do
    exit_type = FactoryBot.create(:exit_type, organization: user.organization)
    exit_type_count = ExitType.for_organization(user.organization).count

    visit exit_types_path

    link = find("a[data-method='delete'][href='#{exit_type_path(exit_type.id)}']")

    within('tbody') do
      expect(page).to have_xpath('.//tr', count: exit_type_count)
      link.click
      expect(page).to have_xpath('.//tr', count: (exit_type_count - 1))
    end
  end
end
