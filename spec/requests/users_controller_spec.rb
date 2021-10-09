require 'rails_helper'

describe UsersController, type: :request do
  include Devise::Test::IntegrationHelpers

  let(:user) { FactoryBot.create(:user) }

  before do
    sign_in user
  end

  describe '#index' do
    it 'should have response code 200 for admin user' do
      user.update(role: 'admin')

      get users_path
      expect(response).to have_http_status(:success)
    end

    it 'should have response code 302 for non-admin user' do
      get users_path
      expect(response).to have_http_status(302)
    end
  end

  describe '#show' do
    it 'should have response code 200 for admin user' do
      user = create(:user, role: "admin")
      sign_in user
      get user_path(user.id)

      expect(response).to have_http_status(:success)
    end

    it 'should have response code 302 for non-admin user' do
      user = create(:user, role: "user")
      sign_in user
      get user_path(user.id)

      expect(response).to have_http_status(302)
    end
  end
end
