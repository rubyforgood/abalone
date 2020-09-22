require 'rails_helper'

describe UsersController do
  include Devise::Test::ControllerHelpers

  let(:user) { FactoryBot.create(:user) }

  before do
    sign_in user
  end

  describe '#index' do
    it 'should have response code 200 for admin user' do
      user.update(role: 'admin')

      get :index
      expect(response.code).to eq '200'
    end

    it 'should have response code 302 for non-admin user' do
      get :index
      expect(response.code).to eq '302'
    end
  end

  describe '#show' do
    it 'should have response code 200 for admin user' do
      user = create(:user, role: "admin")
      sign_in user
      get :show, params: { id: user.id }

      expect(response.code).to eq '200'
    end

    it 'should have response code 302 for non-admin user' do
      user = create(:user, role: "user")
      sign_in user
      get :show, params: { id: user.id }

      expect(response.code).to eq '302'
    end
  end
end
