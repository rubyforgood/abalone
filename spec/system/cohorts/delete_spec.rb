require 'rails_helper'

describe "When I visit the cohort Index page", type: :system do
  let(:user) { create(:user) }

  before do
    sign_in user
  end

  it "Then I click the delete button, cohort should be deleted" do
    cohort1 = create(:cohort, organization: user.organization)
    cohort_count = Cohort.for_organization(user.organization).count

    visit cohorts_path

    link = find("a[data-method='delete'][href='#{cohort_path(cohort1.id)}']")

    within('tbody') do
      expect(page).to have_xpath('.//tr', count: cohort_count)
      link.click
      expect(page).to have_xpath('.//tr', count: (cohort_count - 1))
    end
  end
end
