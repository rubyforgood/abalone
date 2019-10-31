# frozen_string_literal: true

# rubocop:disable Lint/UnneededCopDisableDirective, Metrics/LineLength
# == Schema Information
#
# Table name: spawning_successes
#
#  id                  :bigint           not null, primary key
#  raw                 :boolean          default(TRUE), not null
#  tag                 :string
#  shl_case_number     :string
#  spawning_date       :date
#  date_attempted      :date
#  spawning_success    :string
#  nbr_of_eggs_spawned :decimal(, )
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  processed_file_id   :integer
#
# rubocop:enable Metrics/LineLength, Lint/UnneededCopDisableDirective

require 'rails_helper'

RSpec.describe SpawningSuccess, type: :model do
  let(:spawning_success) { FactoryBot.create :spawning_success }

  describe 'structure' do
    it { is_expected.to have_db_column :tag }
    it { is_expected.to have_db_column :shl_case_number }
    it { is_expected.to have_db_column :spawning_date }
    it { is_expected.to have_db_column :date_attempted }
    it { is_expected.to have_db_column :spawning_success }
    it { is_expected.to have_db_column :nbr_of_eggs_spawned }

    describe 'it only has 10 columns' do
      it { expect(SpawningSuccess.columns.count).to eq 11 }
    end
  end
end
