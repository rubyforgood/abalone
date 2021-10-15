require 'rails_helper'

describe 'When I visit the blazer reporting index page', type: :system do
  let(:user) { create(:user) }

  before do
    sign_in user
  end

  it 'I see the button to create a new query' do
    visit reports.root_path
    expect(page).to have_selector(:link_or_button, 'New Query')
  end
end
