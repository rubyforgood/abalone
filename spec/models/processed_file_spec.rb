# rubocop:disable Lint/RedundantCopDisableDirective, Layout/LineLength
# == Schema Information
#
# Table name: processed_files
#
#  id                :bigint           not null, primary key
#  filename          :string
#  original_filename :string
#  category          :string
#  status            :string
#  job_stats         :jsonb            not null
#  job_errors        :text
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
# rubocop:enable Layout/LineLength, Lint/RedundantCopDisableDirective

require 'rails_helper'

RSpec.describe ProcessedFile, type: :model do
  subject(:processed_file) { build_stubbed(:processed_file) }

  it "has associations" do
    is_expected.to belong_to(:temporary_file).dependent(:destroy).optional
    is_expected.to belong_to(:organization)
  end

  describe "Validations >" do
    subject(:processed_file) { build(:processed_file) }

    it "has a valid factory" do
      expect(processed_file).to be_valid
    end

    it_behaves_like OrganizationScope

    it { is_expected.to validate_exclusion_of(:job_stats).in_array([nil, ""]) }
  end
end
