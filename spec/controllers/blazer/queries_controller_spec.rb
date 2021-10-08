require 'rails_helper'

RSpec.describe Blazer::QueriesController, type: :controller do
  routes { Blazer::Engine.routes }

  let(:user) { FactoryBot.create(:user) }

  before { sign_in(user) }

  describe 'index' do
    before do
      FactoryBot.create_list(:blazer_query, 3, creator: user)
      FactoryBot.create_list(:blazer_query, 7, creator: FactoryBot.create(:user))
    end

    it 'returns queries scoped to current_user\'s organization' do
      get :index
      queries = JSON.parse(response.body)
      expect(queries.count).to eq(3)
    end
  end
end
