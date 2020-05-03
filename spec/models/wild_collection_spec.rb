# rubocop:disable Lint/RedundantCopDisableDirective, Layout/LineLength
# == Schema Information
#
# Table name: wild_collections
#
#  id                                         :bigint           not null, primary key
#  raw                                        :boolean          default(TRUE), not null
#  tag                                        :string
#  collection_date                            :date
#  general_location                           :string
#  precise_location                           :string
#  collection_coodinates                      :point
#  proximity_to_nearest_neighbor              :string
#  collection_method_notes                    :string
#  foot_condition_notes                       :string
#  collection_depth                           :decimal(, )
#  length                                     :decimal(, )
#  weight                                     :decimal(, )
#  gonad_score                                :string
#  predicted_sex                              :string
#  initial_holding_facility                   :string
#  final_holding_facility_and_date_of_arrival :string
#  otc_treatment_completion_date              :date
#  created_at                                 :datetime         not null
#  updated_at                                 :datetime         not null
#  processed_file_id                          :integer
#
# rubocop:enable Layout/LineLength, Lint/RedundantCopDisableDirective

require 'rails_helper'

RSpec.describe WildCollection, type: :model do
  let(:valid_attributes) do
    {
      tag: 'Green_001',
      collection_date: Date.strptime('1/1/19', '%m/%d/%y'),
      general_location: 'Catalina Island',
      precise_location: 'Catalina Island',
      collection_coordinates: '1.317,-100.984',
      proximity_to_nearest_neighbor: '1',
      collection_method_notes: 'spatula',
      foot_condition_notes: 'scrape',
      collection_depth: 100.0,
      length: 3.0,
      weight: 3.0,
      gonad_score: '1 on 11/1/18',
      predicted_sex: 'M?',
      initial_holding_facility: 'AoP',
      final_holding_facility_and_date_of_arrival: 'BML; 2/28/19',
      otc_treatment_completion_date: Date.strptime('3/15/19', '%m/%d/%y'),
      processed_file_id: 1
    }
  end

  before do
    organization = Organization.create!(name: "Organization for testing")
    Facility.create!(name: 'Aquarium of the Pacific', code: 'AOP', organization_id: organization.id)
    Facility.create!(name: 'UC Davis Bodega Marine Laboratory', code: 'BML', organization_id: organization.id)
  end

  include_examples 'happy path'

  include_examples 'a required field', :tag
  include_examples 'a required field', :collection_date
  include_examples 'a required field', :general_location
  include_examples 'a required field', :precise_location
  include_examples 'a required field', :collection_coordinates
  include_examples 'a required field', :initial_holding_facility

  include_examples 'an optional field', :proximity_to_nearest_neighbor
  include_examples 'an optional field', :collection_method_notes
  include_examples 'an optional field', :foot_condition_notes
  include_examples 'an optional field', :collection_depth
  include_examples 'an optional field', :length
  include_examples 'an optional field', :weight
  include_examples 'an optional field', :gonad_score
  include_examples 'an optional field', :predicted_sex
  include_examples 'an optional field', :final_holding_facility_and_date_of_arrival
  include_examples 'an optional field', :otc_treatment_completion_date

  include_examples 'a numeric field', :collection_depth
  include_examples 'a numeric field', :length
  include_examples 'a numeric field', :weight

  describe 'gonad score' do
    include_examples 'validate values for field', :gonad_score do
      let(:valid_values) do
        [
          '0', '1', '2', '3',
          '0?', '1?', '2?', '3?',
          '0-1', '0-1?', '0-2', '0-2?', '0-3', '0-3?',
          '1-2', '1-2?', '1-3', '1-3?',
          '2-3', '2-3?',
          'NA'
        ]
      end

      let(:invalid_values) do
        ['a', '4', '-2', '?']
      end
    end
  end

  describe 'predicted sex' do
    include_examples 'validate values for field', :predicted_sex do
      let(:valid_values) do
        %w[M F M? F?]
      end

      let(:invalid_values) do
        ['a', 'N', '4', '?']
      end
    end
  end

  describe 'initial holding facility' do
    include_examples 'validate values for field', :initial_holding_facility do
      let(:valid_values) do
        %w[AoP AOP BML]
      end

      let(:invalid_values) do
        %w[NA]
      end
    end
  end

  describe 'final holding facility and date of arrival' do
    include_examples 'validate values for field', :final_holding_facility_and_date_of_arrival do
      let(:valid_values) do
        ['AoP; 12/1/18', 'AOP; 1/31/18', 'BML; 1/31/2018']
      end

      let(:invalid_values) do
        %w[AOP 12/1/18]
      end
    end
  end
end
