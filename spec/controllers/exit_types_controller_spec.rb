require 'rails_helper'

describe ExitTypesController do
  include Devise::Test::ControllerHelpers

  let(:user) { FactoryBot.create(:user) }
  let(:exit_type) { FactoryBot.create(:exit_type, organization_id: user.organization.id) }
  let(:exit_type_another_organization) { FactoryBot.create(:exit_type) }
  let!(:to_delete) { FactoryBot.create(:exit_type, organization_id: user.organization.id) }

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

  describe '#new' do
    it 'should have response code 200 for admin user' do
      user.update(role: 'admin')
      sign_in user

      get :new

      expect(response.code).to eq '200'
    end

    it 'should have response code 302 for non-admin user' do
      user.update(role: 'user')
      sign_in user

      get :show, params: { id: exit_type.id}

      expect(response.code).to eq '302'
    end
  end

  describe '#show' do
    it 'should have response code 200 for admin user' do
      user.update(role: 'admin')
      sign_in user

      get :show, params: { id: exit_type.id }

      expect(response.code).to eq '200'
    end

    it 'should have response code 302 for non-admin user' do
      user.update(role: 'user')
      sign_in user

      get :show, params: { id: exit_type.id}

      expect(response.code).to eq '302'
    end

    it 'should have response code 302 for an exit types in another organization' do
      user.update(role: "admin")
      sign_in user

      get :show, params: { id: exit_type_another_organization.id}

      expect(response.code).to eq '302'
    end
  end

  describe '#edit' do
    it 'should have response code 200 for admin user' do
      user.update(role: 'admin')
      sign_in user

      get :edit, params: { id: exit_type.id }

      expect(response.code).to eq '200'
    end

    it 'should have response code 302 for non-admin user' do
      user.update(role: 'user')
      sign_in user

      get :edit, params: { id: exit_type.id}

      expect(response.code).to eq '302'
    end

    it 'should have response code 302 for an exit types in another organization' do
      user.update(role: "admin")
      sign_in user

      get :edit, params: { id: exit_type_another_organization.id}

      expect(response.code).to eq '302'
    end
  end

  describe '#destroy' do
    it 'should not destroy if the user is non-admin' do
      user.update(role: 'user')
      sign_in user

      expect do
        delete :destroy, params: { id: to_delete.id}
      end.to change(ExitType, :count).by(0)
    end

    it 'should not destroy for an exit types in another organization' do
      user.update(role: "admin")
      sign_in user

      to_delete = FactoryBot.create(:exit_type)

      expect do
        delete :destroy, params: { id: to_delete.id}
      end.to change(ExitType, :count).by(0)
    end

    it 'should not destroy if the exit types referenced in a mortality event' do
      user.update(role: "admin")
      sign_in user

      FactoryBot.create(:mortality_event, exit_type_id: to_delete.id)

      expect do
        delete :destroy, params: { id: to_delete.id}
      end.to change(ExitType, :count).by(0)
    end

    it 'should have delete the entity for admin user' do
      user.update(role: "admin")
      sign_in user

      expect do
        delete :destroy, params: { id: to_delete.id}
      end.to change(ExitType, :count).by(-1)
    end
  end
end
