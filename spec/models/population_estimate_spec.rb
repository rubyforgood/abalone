# rubocop:disable Lint/UnneededCopDisableDirective, Metrics/LineLength
# == Schema Information
#
# Table name: population_estimates
#
#  id                :bigint           not null, primary key
#  raw               :boolean          default(TRUE), not null
#  sample_date       :date
#  shl_case_number   :string
#  spawning_date     :date
#  lifestage         :string
#  abundance         :string
#  facility          :string
#  notes             :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  processed_file_id :integer
#
# rubocop:enable Metrics/LineLength, Lint/UnneededCopDisableDirective

require 'rails_helper'

RSpec.describe PopulationEstimate, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:sample_date) }
    it { should validate_presence_of(:shl_case_number) }
    it { should validate_presence_of(:abundance) }
    it { should validate_presence_of(:facility) }

    it { should validate_numericality_of(:abundance) }
  end
end
