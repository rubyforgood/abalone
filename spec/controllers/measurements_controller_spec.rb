require 'rails_helper'

RSpec.describe MeasurementsController, type: :controller do
  include Devise::Test::ControllerHelpers

  let(:user) { FactoryBot.create(:user) }

  before do
    sign_in user
  end

  describe "GET index", :aggregate_failures do
    it "assigns @measurements" do
      measurement = FactoryBot.create(:measurement)
      get :index
      expect(assigns(:measurements)).to eq([measurement])
    end

    it "renders the index template" do
      get :index
      expect(response).to render_template("index")
    end
  end

  describe "GET #show" do
    it "succeed" do
      measurement_id = FactoryBot.create(:measurement).id

      get :show, params: { id: measurement_id }

      expect(response).to be_successful
      expect(response).to render_template(:show)
    end
  end

  describe '#edit', :aggregate_failures do
    it 'should have response code 200 for admin user' do
      measurement = FactoryBot.create(:measurement)
      user.update(role: 'admin')
      sign_in user

      get :edit, params: { id: measurement.id }

      expect(response.code).to eq '200'
    end

    it 'should have response code 302 for non-admin user' do
      measurement = FactoryBot.create(:measurement)
      user.update(role: 'user')
      sign_in user

      get :edit, params: { id: measurement.id}

      expect(response.code).to eq '302'
    end
  end
end
