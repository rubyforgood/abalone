require 'rails_helper'

describe AnimalsController, type: :request do
  include Devise::Test::IntegrationHelpers

  let(:user) { create(:user) }
  let(:animal) { create(:animal, organization_id: user.organization.id) }
  let(:animal_from_another_orga) { create(:animal) }

  before do
    sign_in user
  end

  describe '#show' do
    it 'should have response code 302 for an animal in another organization' do
      animal_from_another_orga = create(:animal)
      get animal_path(animal_from_another_orga.id)
      expect(response).to have_http_status(302)
    end

    it 'should have response code 200 for an animal in the current organization' do
      get animal_path(animal.id)
      expect(response).to have_http_status(200)
    end
  end

  describe '#edit' do
    it 'should have response code 302 for an animal in another organization' do
      get edit_animal_path(animal_from_another_orga.id)
      expect(response).to have_http_status(302)
    end
    it 'should have response code 200 for an animal in the current organization' do
      get edit_animal_path(animal.id)
      expect(response).to have_http_status(200)
    end
  end

  describe '#update' do
    let(:new_attributes) do
      { shl_numbers_codes: "0001-M-TEST" }
    end

    it 'should not have update an animal in another organization' do
      put animal_url(animal_from_another_orga), params: { animal: new_attributes }
      animal_from_another_orga.reload
      expect(animal_from_another_orga.shl_number_codes).not_to eq(new_attributes[:shl_numbers_codes])
    end

    it 'should have update the animal in the current organization' do
      put animal_url(animal), params: { animal: new_attributes }
      animal.reload
      expect(animal.shl_number_codes).to eq(new_attributes[:shl_numbers_codes])
    end
  end

  describe '#destroy' do
    it 'should not delete an animal in another organization' do
      animal_from_another_orga = create(:animal)
      expect do
        delete animal_path(animal_from_another_orga)
      end.to change(Animal, :count).by(0)
    end

    it 'should have delete the entity' do
      animal = create(:animal, organization_id: user.organization.id)
      expect do
        delete animal_path(animal)
      end.to change(Animal, :count).by(-1)
    end
  end
end
