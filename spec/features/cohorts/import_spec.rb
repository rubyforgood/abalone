require "rails_helper"

RSpec.describe "Cohort Import" do
  let(:user) { create(:user) }
  let(:cohort_csv) { "tmp/cohort_import_test.csv" }

  let(:enclosure) { build(:enclosure) }
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
      cohort.enclosure.name,
      cohort.enclosure.location.name
    ]
  end

  before do
    CSV.open(cohort_csv, "wb") do |csv|
      rows.each do |row|
        csv << row
      end
    end
  end

  before(:each) { sign_in user }

  after(:each) { File.delete(cohort_csv) }

  describe 'valid csv' do
    let(:csv) { CSV.open(cohort_csv, "r") }

    it "has headers and a row", :aggregate_failures do
      expect(csv.readline).to eq(%w[name female_tag male_tag enclosure location])
      expect(csv.readline).to eq(
        [
          cohort1.name, cohort1.female_tag, cohort1.male_tag,
          cohort1.enclosure.name, cohort1.enclosure.location.name
        ]
      )
    end
  end

  it "creates cohort from a CSV file", :aggregate_failures do
    visit new_cohort_import_path
    attach_file("cohort_csv", cohort_csv)
    click_on "Submit"

    cohort = Cohort.first

    expect(cohort.organization_id).to eql(user.organization.id)
    expect(cohort.name).to eq cohort1.name
    expect(cohort.female_tag).to eq cohort1.female_tag
    expect(cohort.male_tag).to eq cohort1.male_tag
    expect(cohort.enclosure.name).to eq cohort1.enclosure.name
    expect(cohort.enclosure.location.name).to eq cohort1.location.name
  end
end
