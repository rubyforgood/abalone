# rubocop:disable Lint/RedundantCopDisableDirective, Layout/LineLength
# == Schema Information
#
# Table name: facilities
#
#  id         :bigint           not null, primary key
#  name       :string
#  code       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# rubocop:enable Layout/LineLength, Lint/RedundantCopDisableDirective

require "rails_helper"

RSpec.describe Facility, type: :model do
  subject(:facility) { build_stubbed(:facility) }

  it "has associations" do
    is_expected.to have_many(:locations)
    is_expected.to belong_to(:organization)
  end

  describe "structure" do
    it { is_expected.to have_db_column :name }
    it { is_expected.to have_db_column :code }
    it { is_expected.to have_db_column :organization_id }

    it "only has 6 columns" do
      expect(described_class.columns.count).to eq(6)
    end
  end

  describe "Validations >" do
    subject(:facility) { build(:facility) }

    it_behaves_like OrganizationScope

    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:code) }
    it { is_expected.to validate_uniqueness_of(:code).scoped_to(:organization_id) }
  end

  describe "#to_s" do
    it "returns the facility code" do
      expect(facility.to_s).to eq(facility.code)
    end
  end

  describe ".valid_codes" do
    before do
      %w[first_code second_code third_code].each { |code| create(:facility, code: code) }
    end

    it "returns upcased facility codes in upcase format" do
      expect(described_class.valid_codes).to match(%w[FIRST_CODE SECOND_CODE THIRD_CODE])
    end
  end

  describe ".valid_code?" do
    before { create(:facility, code: "my_code") }

    it "returns true if code exists for a facility" do
      expect(described_class.valid_code?("MY_CODE")).to eq(true)
    end

    it "returns false if code does not exist for a facility" do
      expect(described_class.valid_code?("NO_CODE")).to eq(false)
    end
  end
end
