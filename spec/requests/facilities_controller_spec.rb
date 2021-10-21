require 'rails_helper'

describe FacilitiesController, type: :request do
  include Devise::Test::IntegrationHelpers

  let(:user) { create(:user) }
  let(:facility) { create(:facility, organization_id: user.organization.id) }
  let(:facility_from_another_orga) { create(:facility) }

  before do
    sign_in user
  end

  describe '#show' do
    it 'should have response code 302 for a facility in another organization' do
      facility_from_another_orga = create(:facility)
      get facility_path(facility_from_another_orga.id)
      expect(response).to have_http_status(302)
    end

    it 'should have response code 200 for a facility in the current organization' do
      get facility_path(facility.id)
      expect(response).to have_http_status(200)
    end
  end

  describe '#edit' do
    it 'should have response code 302 for a facility in another organization' do
      get edit_facility_path(facility_from_another_orga.id)
      expect(response).to have_http_status(302)
    end
    it 'should have response code 200 for a facility in the current organization' do
      get edit_facility_path(facility.id)
      expect(response).to have_http_status(200)
    end
  end

  describe '#update' do
    let(:new_attributes) do
      { name: "updated" }
    end

    it 'should not have update a facility in another organization' do
      put facility_url(facility_from_another_orga), params: { facility: new_attributes }
      facility_from_another_orga.reload
      expect(facility_from_another_orga.name).not_to eq(new_attributes[:name])
    end

    it 'should have update the facility in the current organization' do
      put facility_url(facility), params: { facility: new_attributes }
      facility.reload
      expect(facility.name).to eq(new_attributes[:name])
    end
  end

  describe '#destroy' do
    it 'should not delete a facility in another organization' do
      facility_from_another_orga = create(:facility)
      expect do
        delete facility_path(facility_from_another_orga)
      end.to change(Facility, :count).by(0)
    end

    it 'should have delete the entity' do
      facility = create(:facility, organization_id: user.organization.id)
      expect do
        delete facility_path(facility)
      end.to change(Facility, :count).by(-1)
    end
  end
end
