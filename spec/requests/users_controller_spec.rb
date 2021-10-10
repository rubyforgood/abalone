require 'rails_helper'

describe UsersController, type: :request do
  include Devise::Test::IntegrationHelpers

  let(:user) { FactoryBot.create(:user) }
  let(:user_from_another_orga) { create(:user) }

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

    it 'should have response code 302 for a user in another organization' do
      user.update(role: 'admin')

      user_from_another_orga = FactoryBot.create(:user)
      get user_path(user_from_another_orga.id)
      expect(response).to have_http_status(302)
    end

    it 'should have response code 200 for a user in the current organization' do
      user.update(role: 'admin')

      get user_path(user.id)
      expect(response).to have_http_status(200)
    end
  end

  describe '#edit' do
    it 'should have response code 302 for a non admin user' do
      get edit_user_path(user.id)
      expect(response).to have_http_status(302)
    end

    it 'should have response code 302 for a user in another organization' do
      user.update(role: 'admin')

      get edit_user_path(user_from_another_orga.id)
      expect(response).to have_http_status(302)
    end

    it 'should have response code 200 for a user in the current organization' do
      user.update(role: 'admin')

      get edit_user_path(user.id)
      expect(response).to have_http_status(200)
    end
  end

  describe '#update' do
    let(:new_attributes) do
      { email: "user_updated@example.com" }
    end

    it 'should have response code 302 for a non admin user' do
      put user_url(user_from_another_orga), params: { user: new_attributes }
      user_from_another_orga.reload
      expect(user_from_another_orga.email).not_to eq(new_attributes[:email])
    end

    it 'should not have update a user in another organization' do
      user.update(role: 'admin')

      put user_url(user_from_another_orga), params: { user: new_attributes }
      user_from_another_orga.reload
      expect(user_from_another_orga.email).not_to eq(new_attributes[:email])
    end

    it 'should have update the user in the current organization' do
      user.update(role: 'admin')

      put user_url(user), params: { user: new_attributes }
      user.reload
      expect(user.email).to eq(new_attributes[:email])
    end
  end

  describe '#destroy' do
    it 'should have not delete if non admin user' do
      user_to_delete = create(:user, organization_id: user.organization_id)
      expect do
        delete exit_type_path(user_to_delete)
      end.to change(ExitType, :count).by(0)
    end

    it 'should not delete a user in another organization' do
      user.update(role: 'admin')

      user_from_another_orga = create(:user)
      expect do
        delete user_path(user_from_another_orga)
      end.to change(User, :count).by(0)
    end

    it 'should have delete the entity' do
      user.update(role: 'admin')

      user_to_delete = create(:user, organization_id: user.organization_id)
      expect do
        delete user_path(user_to_delete)
      end.to change(User, :count).by(-1)
    end
  end
end
