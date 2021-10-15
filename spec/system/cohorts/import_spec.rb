require "rails_helper"

RSpec.describe "Cohort Import", type: :system do
  let(:user) { create(:user) }
  let(:cohort_csv) { "tmp/cohort_import_test.csv" }

  let(:enclosure) { create(:enclosure, organization: user.organization) }
  let(:cohort1) { build(:cohort, enclosure: enclosure) }
  let(:cohort2) { build(:cohort, enclosure: enclosure) }

  let(:header) { CSV.open("public/samples/cohort.csv").readline }
  let(:row1) { build_csv_row(cohort1) }
  let(:row2) { build_csv_row(cohort2) }
  let(:rows) { [header, row1] }

  def build_csv_row(cohort)
    [
      cohort.name,
      cohort.female_tag,
      cohort.male_tag,
      cohort.enclosure.name
    ]
  end

  before(:each) do
    sign_in user
    CSV.open(cohort_csv, "wb") do |csv|
      rows.each do |row|
        csv << row
      end
    end
  end

  after(:each) { File.delete(cohort_csv) }

  describe "valid csv" do
    let(:csv) { CSV.open(cohort_csv, "r") }

    it "has headers and a row", :aggregate_failures do
      expect(csv.readline).to eq(%w[name female_tag male_tag enclosure])
      expect(csv.readline).to eq(
        [
          cohort1.name, cohort1.female_tag, cohort1.male_tag,
          cohort1.enclosure.name
        ]
      )
    end
  end

  describe "from CSV file" do
    subject(:upload_csv!) do
      visit new_cohort_import_path
      attach_file("csv_import_form[csv_file]", cohort_csv)
      click_on "Submit"
      page
    end

    context "when a single row of data exists" do
      let(:cohort) { Cohort.first }

      it "creates a cohort", :aggregate_failures do
        is_expected.to have_current_path(cohorts_path)
        expect(cohort.organization_id).to eql(user.organization.id)
        expect(cohort.name).to eq cohort1.name
        expect(cohort.female_tag).to eq cohort1.female_tag
        expect(cohort.male_tag).to eq cohort1.male_tag
        expect(cohort.enclosure.name).to eq enclosure.name
        expect(cohort.enclosure.location.name).to eq enclosure.location.name
      end
    end

    context "when two rows of data exists" do
      let(:rows) { [header, row1, row2] }
      let(:cohort) { Cohort.first }
      let(:other_cohort) { Cohort.last }

      it "creates two coherts", :aggregate_failures do
        is_expected.to have_current_path(cohorts_path)
        expect(cohort.organization_id).to eql(user.organization.id)
        expect(cohort.name).to eq cohort1.name
        expect(cohort.female_tag).to eq cohort1.female_tag
        expect(cohort.male_tag).to eq cohort1.male_tag
        expect(cohort.enclosure.name).to eq enclosure.name
        expect(cohort.enclosure.location.name).to eq enclosure.location.name

        expect(other_cohort.organization_id).to eql(user.organization.id)
        expect(other_cohort.name).to eq cohort2.name
        expect(other_cohort.female_tag).to eq cohort2.female_tag
        expect(other_cohort.male_tag).to eq cohort2.male_tag
        expect(other_cohort.enclosure.name).to eq enclosure.name
        expect(other_cohort.enclosure.location.name).to eq enclosure.location.name
      end
    end

    context "when all records upload successfully" do
      it "displays success" do
        upload_csv!
        visit csv_index_path

        expect(page).to have_text("0 records had errors")
      end
    end

    context "when there are errors" do
      let(:cohort) { Cohort.new }

      before do
        allow(Cohort).to receive(:new).and_return(cohort)
        allow(cohort).to receive(:save).and_return false
      end

      it "displays error message" do
        upload_csv!
        visit csv_index_path

        expect(Cohort).to have_received(:new)
        expect(page).to have_text("1 records had errors")
      end
    end
  end
end
