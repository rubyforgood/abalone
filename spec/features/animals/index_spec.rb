require 'rails_helper'

describe "When I visit the animal Index page" do
  let(:user) { create(:user) }

  before do
    sign_in user
  end

  it "Then I see a list of all the animals" do
    animal = FactoryBot.create(:animal, collection_year: 2, tag_id: 2, organization: user.organization)
    animal_count = Animal.for_organization(user.organization).count

    visit animals_path

    expect(page).to have_content("Collection Year")
    expect(page).to have_content("Tag ID")
    expect(page).to have_link("New Animal")
    expect(page).to have_link("Show")
    expect(page).to have_link(nil, href: edit_animal_path(animal.id))
    expect(page).to have_selector("a[data-method='delete'][href='#{animal_path(animal.id)}']")

    expect(page).to have_content(animal.collection_year)
    expect(page).to have_content(animal.tag_id)

    within('tbody') do
      expect(page).to have_xpath('.//tr', count: animal_count)
    end
  end

  it "should allow exporting to csv" do
    animals = create_list(:animal, 5, organization: user.organization)

    visit animals_path

    click_on "Export to CSV"

    expect(page.response_headers['Content-Type']).to eql "text/csv"
    expect(page).to have_content(Animal.exportable_columns.join(','))

    animals.each { |animal| expect(page).to have_content(animal.pii_tag) }
  end
end
