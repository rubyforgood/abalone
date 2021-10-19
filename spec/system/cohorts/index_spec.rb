require 'rails_helper'

describe "When I visit the cohort Index page", type: :system do
  let(:user) { create(:user) }

  before do
    sign_in user
  end

  it "Then I see a list of all the cohorts" do
    cohort = create(:cohort, organization: user.organization)

    visit cohorts_path

    expect(page).to have_content("Name")
    expect(page).to have_content("Female")
    expect(page).to have_content("Male")
    expect(page).to have_content("Cohort")

    expect(page).to have_link("New Cohort")

    expect(page).to have_link("Show")
    expect(page).to have_link(nil, href: edit_cohort_path(cohort.id))
    expect(page).to have_selector("a[data-method='delete'][href='#{cohort_path(cohort.id)}']")
  end

  it "should allow exporting to csv" do
    cohorts = create_list(:cohort, 5, organization: user.organization)

    visit cohorts_path

    find('#export_button').click

    expect(page.response_headers['Content-Type']).to eql "text/csv"
    expect(page).to have_content(Cohort.exportable_columns.join(','))

    cohorts.each { |cohort| expect(page).to have_content(cohort.name) }
  end

  describe "importing csv" do
    subject do
      visit cohorts_path
      page
    end

    it { is_expected.to have_link "Upload CSV", href: new_cohort_import_path }
  end
end
