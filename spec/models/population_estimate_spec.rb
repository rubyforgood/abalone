# frozen_string_literal: true

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
  let(:population_estimate) { FactoryBot.create :population_estimate }

  describe 'structure' do
    it { is_expected.to have_db_column :sample_date }
    it { is_expected.to have_db_column :shl_case_number }
    it { is_expected.to have_db_column :spawning_date }
    it { is_expected.to have_db_column :lifestage }
    it { is_expected.to have_db_column :abundance }
    it { is_expected.to have_db_column :facility }
    it { is_expected.to have_db_column :notes }

    describe 'it only has 11 columns' do
      it { expect(PopulationEstimate.columns.count).to eq 12 }
    end
  end
end
