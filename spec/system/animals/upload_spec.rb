require 'rails_helper'

describe "When I visit the animal Upload Csv page", type: :system do
  let(:user) { create(:user) }

  before { sign_in user }

  it "Then I can upload a CSV of animals to import" do
    visit csv_upload_animals_path

    expect(page).to have_link("Click here")
    expect(page).to have_content("Click here for a sample csv file.")

    attach_file('animal_csv', "#{Rails.root}/spec/fixtures/files/animals.csv")

    click_on 'Submit'

    expect(page).to have_current_path(animals_path)

    visit animals_path

    within('tbody') { expect(page).to have_xpath('.//tr', count: 2) }

    # Verify no duplicates and assigned to correct org
    animals = Animal.where(tag: "Y002")
    expect(animals.count).to eql(1)
    expect(animals.first.organization_id).to eql(user.organization.id)
  end
end
