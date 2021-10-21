require 'rails_helper'

describe EnclosuresController, type: :request do
  include Devise::Test::IntegrationHelpers

  let(:user) { create(:user) }
  let(:enclosure) { create(:enclosure, organization_id: user.organization.id) }
  let(:enclosure_from_another_orga) { create(:enclosure) }

  before do
    sign_in user
  end

  describe '#show' do
    it 'should have response code 302 for an enclosure in another organization' do
      enclosure_from_another_orga = create(:enclosure)
      get enclosure_path(enclosure_from_another_orga.id)
      expect(response).to have_http_status(302)
    end

    it 'should have response code 200 for an enclosure in the current organization' do
      get enclosure_path(enclosure.id)
      expect(response).to have_http_status(200)
    end
  end

  describe '#edit' do
    it 'should have response code 302 for an enclosure in another organization' do
      get edit_enclosure_path(enclosure_from_another_orga.id)
      expect(response).to have_http_status(302)
    end
    it 'should have response code 200 for an enclosure in the current organization' do
      get edit_enclosure_path(enclosure.id)
      expect(response).to have_http_status(200)
    end
  end

  describe '#update' do
    let(:new_attributes) do
      { name: "updated" }
    end

    it 'should not have update an enclosure in another organization' do
      put enclosure_url(enclosure_from_another_orga), params: { enclosure: new_attributes }
      enclosure_from_another_orga.reload
      expect(enclosure_from_another_orga.name).not_to eq(new_attributes[:name])
    end

    it 'should have update the enclosure in the current organization' do
      put enclosure_url(enclosure), params: { enclosure: new_attributes }
      enclosure.reload
      expect(enclosure.name).to eq(new_attributes[:name])
    end
  end

  describe '#destroy' do
    it 'should not delete an enclosure in another organization' do
      enclosure_from_another_orga = create(:enclosure)
      expect do
        delete enclosure_path(enclosure_from_another_orga)
      end.to change(Enclosure, :count).by(0)
    end

    it 'should have delete the entity' do
      enclosure = create(:enclosure, organization_id: user.organization.id)
      expect do
        delete enclosure_path(enclosure)
      end.to change(Enclosure, :count).by(-1)
    end
  end
end
