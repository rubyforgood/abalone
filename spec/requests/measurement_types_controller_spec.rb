require 'rails_helper'

describe MeasurementTypesController, type: :request do
  include Devise::Test::IntegrationHelpers

  let(:user) { create(:user) }
  let(:measurement_type) { create(:measurement_type, organization_id: user.organization.id) }
  let(:measurement_type_from_another_orga) { create(:measurement_type) }

  before do
    sign_in user
  end

  describe '#index' do
    it 'should have response code 302 for a non admin user' do
      get measurement_types_path
      expect(response).to have_http_status(302)
    end

    it 'should have response code 200 for an admin user' do
      user.update(role: 'admin')

      get measurement_types_path
      expect(response).to have_http_status(200)
    end
  end

  describe '#edit' do
    it 'should have response code 302 for a non admin user' do
      get edit_measurement_type_path(measurement_type.id)
      expect(response).to have_http_status(302)
    end

    it 'should have response code 302 for a measurement_type in another organization' do
      user.update(role: 'admin')

      get edit_measurement_type_path(measurement_type_from_another_orga.id)
      expect(response).to have_http_status(302)
    end

    it 'should have response code 200 for a measurement_type in the current organization' do
      user.update(role: 'admin')

      get edit_measurement_type_path(measurement_type.id)
      expect(response).to have_http_status(200)
    end
  end

  describe '#update' do
    let(:new_attributes) do
      { name: "updated" }
    end

    it 'should not have update an measurement_type if non admin user' do
      put measurement_type_url(measurement_type_from_another_orga), params: { measurement_type: new_attributes }
      measurement_type_from_another_orga.reload
      expect(measurement_type_from_another_orga.name).not_to eq(new_attributes[:name])
    end

    it 'should not have update an measurement_type in another organization' do
      user.update(role: 'admin')

      put measurement_type_url(measurement_type_from_another_orga), params: { measurement_type: new_attributes }
      measurement_type_from_another_orga.reload
      expect(measurement_type_from_another_orga.name).not_to eq(new_attributes[:name])
    end

    it 'should have update the measurement_type in the current organization' do
      user.update(role: 'admin')

      put measurement_type_url(measurement_type), params: { measurement_type: new_attributes }
      measurement_type.reload
      expect(measurement_type.name).to eq(new_attributes[:name])
    end
  end

  describe '#destroy' do
    it 'should have response code 302 for a non admin user' do
      measurement_type_from_another_orga = create(:measurement_type)
      expect do
        delete measurement_type_path(measurement_type_from_another_orga)
      end.to change(MeasurementType, :count).by(0)
    end

    it 'should not delete a measurement_type in another organization' do
      user.update(role: 'admin')

      measurement_type_from_another_orga = create(:measurement_type)
      expect do
        delete measurement_type_path(measurement_type_from_another_orga)
      end.to change(MeasurementType, :count).by(0)
    end

    it 'should have delete the entity' do
      user.update(role: 'admin')

      measurement_type = create(:measurement_type, organization_id: user.organization.id)
      expect do
        delete measurement_type_path(measurement_type)
      end.to change(MeasurementType, :count).by(-1)
    end
  end
end
