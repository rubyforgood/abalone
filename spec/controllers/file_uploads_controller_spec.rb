require 'rails_helper'

describe FileUploadsController do
  include Devise::Test::ControllerHelpers

  let!(:user) { FactoryBot.create(:user) }
  let!(:measurement_type1) { create(:measurement_type, organization: user.organization) }
  let!(:measurement_type2) { create(:measurement_type, name: 'count', unit: 'number', organization: user.organization) }
  let!(:measurement_type3) { create(:measurement_type, name: 'gonad score', unit: 'number', organization: user.organization) }
  let!(:cohort) { create(:cohort, name: 'Test Cohort', organization: user.organization) }

  before do
    sign_in user
  end

  describe '#upload' do
    it 'should upload multiple files successfully' do
      post :upload, params: valid_files_params

      expect(assigns[:file_uploads].length).to eq 2
      expect(response.code).to eq '200'

      assigns[:file_uploads].each do |upload|
        expect(upload.result_message).to include 'Successfully queued'
      end
    end

    it 'should reject a CSV with incorrect headers' do
      post :upload, params: invalid_header_file_params

      expect(response.code).to eq '200'
      expect(assigns[:file_uploads][0].result_message)
        .to include 'Invalid category'
    end

    it 'should give an error message if no CSV is uploaded' do
      post :upload, params: invalid_file_params

      expect(response.code).to eq '400'
    end
  end

  describe '#new' do
    it 'should build the categories list' do
      get :new
      expect(assigns[:categories].length > 2)
      expect(response.code).to eq '200'
    end
  end

  describe '#index' do
    it 'should have response code 200' do

      get :index
      expect(response.code).to eq '200'
    end
  end

  describe '#show' do
    it 'should have response code 200' do
      file = create(:processed_file)
      get :show, params: { id: file.id }
      expect(response.code).to eq '200'
    end
  end

  def valid_files_params
    {
      'category': 'Measurement',
      'input_files': [
        fixture_file_upload('/basic_custom_measurement.csv', 'text/csv'),
        fixture_file_upload('/basic_custom_measurement_with_spaces.csv', 'text/csv')
      ]
    }
  end

  def invalid_header_file_params
    {
      'category': 'Invalid Category',
      'input_files': [
        fixture_file_upload('basic_custom_measurement.csv', 'text/csv')
      ]
    }
  end

  def invalid_file_params
    {
      'category': 'Measurement',
      'input_files': []
    }
  end
end
