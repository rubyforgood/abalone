require 'rails_helper'

describe CohortsController, type: :request do
  include Devise::Test::IntegrationHelpers

  let(:user) { create(:user) }
  let(:cohort) { create(:cohort, organization_id: user.organization.id) }
  let(:cohort_from_another_orga) { create(:cohort) }

  before do
    sign_in user
  end

  describe '#show' do
    it 'should have response code 302 for an cohort in another organization' do
      cohort_from_another_orga = create(:cohort)
      get cohort_path(cohort_from_another_orga.id)
      expect(response).to have_http_status(302)
    end

    it 'should have response code 200 for an cohort in the current organization' do
      get cohort_path(cohort.id)
      expect(response).to have_http_status(200)
    end
  end

  describe '#edit' do
    it 'should have response code 302 for an cohort in another organization' do
      get edit_cohort_path(cohort_from_another_orga.id)
      expect(response).to have_http_status(302)
    end
    it 'should have response code 200 for an cohort in the current organization' do
      get edit_cohort_path(cohort.id)
      expect(response).to have_http_status(200)
    end
  end

  describe '#update' do
    let(:new_attributes) do
      { name: "updated" }
    end

    it 'should not have update an cohort in another organization' do
      put cohort_url(cohort_from_another_orga), params: { cohort: new_attributes }
      cohort_from_another_orga.reload
      expect(cohort_from_another_orga.name).not_to eq(new_attributes[:name])
    end

    it 'should have update the cohort in the current organization' do
      put cohort_url(cohort), params: { cohort: new_attributes }
      cohort.reload
      expect(cohort.name).to eq(new_attributes[:name])
    end
  end

  describe '#destroy' do
    it 'should not delete an cohort in another organization' do
      cohort_from_another_orga = create(:cohort)
      expect do
        delete cohort_path(cohort_from_another_orga)
      end.to change(Cohort, :count).by(0)
    end

    it 'should have delete the entity' do
      cohort = create(:cohort, organization_id: user.organization.id)
      expect do
        delete cohort_path(cohort)
      end.to change(Cohort, :count).by(-1)
    end
  end
end
