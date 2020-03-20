require 'rails_helper'

describe ReportsController do
  include Devise::Test::ControllerHelpers

  let(:user) { FactoryBot.create(:user) }

  before do
    sign_in user
  end
  
  describe '#index' do
    it 'should have response code 200' do
      get :index
      expect(response.code).to eq '200'
    end
  end

  describe '#lengths_for_measurement' do
    it 'should have response code 200' do
      file = create(:processed_file)
      population_estimate = create(:population_estimate)

      get :lengths_for_measurement, params: { 
        processed_file_id: file.id, 
        shl_case_number: population_estimate.shl_case_number,
        date: population_estimate.sample_date,
      }, format: :json
      
      expect(response.code).to eq '200'
      expect { JSON.parse(response.body) }.not_to raise_error
    end
  end
end
