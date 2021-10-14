require 'rails_helper'

describe 'When I visit the New Measurements page', type: :system do
  let(:user) { create(:user) }

  before do
    sign_in user
    visit new_measurement_path
  end

  it 'Then I can generate a template for my selected measurements' do
    expect(page).to have_selector('label.sr-only')
    expect(page).to have_content 'I am taking measurements of animals'
    expect(page).to have_content 'I want to measure length and gonad score'
    expect(page).to have_link('Generate Template')
  end
end
