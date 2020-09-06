require 'rails_helper'

describe "upload TaggedAnimalAssessment category", type: :feature do
  let(:user) { create(:user) }
  let(:file_with_spaces) { "#{Rails.root}/spec/fixtures/basic_custom_measurement_with_spaces.csv" }
  let(:file_without_spaces) { "#{Rails.root}/spec/fixtures/basic_custom_measurement.csv" }
  let(:expected_success_message) { 'Successfully queued spreadsheet for import' }
  let(:temporary_file) { create(:temporary_file, contents: File.read(valid_file)) }
  let(:measurements_comparison) { 
    [
      {name: "Flavor", value: "Salty", measurement_event_name: "Salty", tank_name: "Support Rack 3"},
      {name: "Flavor", value: "WAY too salty", measurement_event_name: "WAY too salty", tank_name: "AB-17"},
      {name: "Good", value: nil, measurement_event_name: nil, tank_name: "Flavor"},
      {name: "Flavor", value: "Good", measurement_event_name: "Good", tank_name: "The Water Bottle at My Desk"},
      {name: "Flavor", value: "Excellent", measurement_event_name: "Excellent", tank_name: "Office Water Cooler"},
      {name: "Tanning Lotion Smell", value: "Sort of like Sardine Oil", measurement_event_name: "Sort of like Sardine Oil", tank_name: "CB Husband Tanning Salon"}
    ]
  }

  before do
    sign_in user
    visit new_file_upload_path
  end

  context 'when user successfully uploads a CSV file with spaces in the header and values' do
    it "strips spaces and generates no errors" do
      expect do
        upload_file("Measurement", [file_with_spaces])
      end.to change { ProcessedFile.count }.by(1)

      ProcessedFile.all.each do |processed_file|
        expect(processed_file.status).to eq "Processed"
        expect(processed_file.job_errors).to eq(nil)
        expect(processed_file.job_stats).to eq(
          {
            "row_count" => 6,
            "rows_imported" => 6,
            "shl_case_numbers"=>{}
          }
        )
      end
      measurements = []
      Measurement.all.each do |measurement|
        measurements << {
          name: measurement.name,
          value: measurement.value,
          measurement_event_name: measurement.value,
          tank_name: measurement.tank.name
        }
      end
      expect(measurements).to eq(measurements_comparison)
      expect(page).to have_content expected_success_message
    end
  end

end