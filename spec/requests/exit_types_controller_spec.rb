require 'rails_helper'

describe ExitTypesController, type: :request do
  include Devise::Test::IntegrationHelpers

  let(:user) { create(:user) }
  let(:exit_type) { create(:exit_type, organization_id: user.organization.id) }
  let(:exit_type_from_another_orga) { create(:exit_type) }

  before do
    sign_in user
  end

  describe '#index' do
    it 'should have response code 302 for a non admin user' do
      get exit_types_path
      expect(response).to have_http_status(302)
    end

    it 'should have response code 200 for an admin user' do
      user.update(role: 'admin')

      get exit_type_path(exit_type.id)
      expect(response).to have_http_status(200)
    end
  end

  describe '#show' do
    it 'should have response code 302 for a non admin user' do
      get exit_type_path(exit_type.id)
      expect(response).to have_http_status(302)
    end

    it 'should have response code 302 for a exit_type in another organization' do
      user.update(role: 'admin')

      exit_type_from_another_orga = FactoryBot.create(:exit_type)
      get exit_type_path(exit_type_from_another_orga.id)
      expect(response).to have_http_status(302)
    end

    it 'should have response code 200 for a exit_type in the current organization' do
      user.update(role: 'admin')

      get exit_type_path(exit_type.id)
      expect(response).to have_http_status(200)
    end
  end

  describe '#edit' do
    it 'should have response code 302 for a non admin user' do
      get edit_exit_type_path(exit_type.id)
      expect(response).to have_http_status(302)
    end

    it 'should have response code 302 for a exit_type in another organization' do
      user.update(role: 'admin')

      get edit_exit_type_path(exit_type_from_another_orga.id)
      expect(response).to have_http_status(302)
    end
    it 'should have response code 200 for a exit_type in the current organization' do
      user.update(role: 'admin')

      get edit_exit_type_path(exit_type.id)
      expect(response).to have_http_status(200)
    end
  end

  describe '#update' do
    let(:new_attributes) do
      { name: "updated" }
    end

    it 'should have response code 302 for a non admin user' do
      put exit_type_url(exit_type_from_another_orga), params: { exit_type: new_attributes }
      exit_type_from_another_orga.reload
      expect(exit_type_from_another_orga.name).not_to eq(new_attributes[:name])
    end

    it 'should not have update a exit_type in another organization' do
      user.update(role: 'admin')

      put exit_type_url(exit_type_from_another_orga), params: { exit_type: new_attributes }
      exit_type_from_another_orga.reload
      expect(exit_type_from_another_orga.name).not_to eq(new_attributes[:name])
    end

    it 'should have update the exit_type in the current organization' do
      user.update(role: 'admin')

      put exit_type_url(exit_type), params: { exit_type: new_attributes }
      exit_type.reload
      expect(exit_type.name).to eq(new_attributes[:name])
    end
  end

  describe '#destroy' do
    it 'should have not delete if non admin user' do
      exit_type = create(:exit_type)
      expect do
        delete exit_type_path(exit_type)
      end.to change(ExitType, :count).by(0)
    end

    it 'should not delete a exit_type in another organization' do
      user.update(role: 'admin')

      exit_type_from_another_orga = create(:exit_type)
      expect do
        delete exit_type_path(exit_type_from_another_orga)
      end.to change(ExitType, :count).by(0)
    end

    it 'should not delete if the exit types referenced in a mortality event' do
      user.update(role: "admin")

      exit_type = create(:exit_type, organization_id: user.organization.id)
      create(:mortality_event, exit_type_id: exit_type.id)

      expect do
        delete exit_type_path(exit_type)
      end.to change(ExitType, :count).by(0)
    end

    it 'should have delete the entity' do
      user.update(role: 'admin')

      exit_type = create(:exit_type, organization_id: user.organization.id)
      expect do
        delete exit_type_path(exit_type)
      end.to change(ExitType, :count).by(-1)
    end
  end
end
