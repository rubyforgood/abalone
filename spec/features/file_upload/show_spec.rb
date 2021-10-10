require 'rails_helper'

describe "When I visit the File Uploads show page", type: :feature do
  let(:user) { create(:user) }
  let(:organization) { create(:organization) }

  let!(:measurement_type1) { create(:measurement_type, organization: user.organization) }
  let!(:measurement_type2) { create(:measurement_type, name: 'count', unit: 'number', organization: user.organization) }
  let!(:measurement_type3) { create(:measurement_type, name: 'gonad score', unit: 'number', organization: user.organization) }
  let!(:cohort) { create(:cohort, name: 'Test Cohort', organization: user.organization) }

  let(:file) { File.read(Rails.root.join("spec/fixtures/files/basic_custom_measurement.csv")) }
  let(:processed_file) { create(:processed_file, organization: user.organization) }
  let(:category_name) { "Measurement" }

  before do
    sign_in user
  end

  it "I can't see the content of an import of another organization" do
    processed_file = create(:processed_file)

    visit show_processed_file_path(processed_file.id)
    expect(page).to have_content("You can only interact with data of your organization")
  end

  it "shows all the values that have been imported" do
    expect do
      CsvImporter.new(file, category_name, processed_file.id, user.organization).call
    end.to change { Measurement.count }

    visit show_processed_file_path(processed_file.id)
    expect(page).to have_content("Processed File")

    within(".table thead") do
      Measurement::HEADERS.keys.map(&:downcase).each do |header|
        expect(page).to have_content(header)
      end
    end

    within(".table tbody") do
      Measurement.find_each do |measurement|
        expect(page).to have_content(measurement.date)
        expect(page).to have_content(measurement.subject_type)
        expect(page).to have_content(measurement.measurement_type_name)
        expect(page).to have_content(measurement.value)
        expect(page).to have_content(measurement.measurement_event_name)

        case measurement.subject
        when Cohort
          expect(measurement.cohort_name).not_to be_nil
          expect(page).to have_content(measurement.cohort_name)
        when Enclosure
          expect(measurement.enclosure_name).not_to be_nil
          expect(page).to have_content(measurement.enclosure_name)
        else
          expect(measurement.animal_tag).not_to be_nil
          expect(page).to have_content(measurement.animal_tag)
        end
      end
    end
  end
end
