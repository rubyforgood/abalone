require 'rails_helper'

describe "remove leading and trailing spaces from csv headers and values", type: :system do
  let(:user) { create(:user, organization: organization) }
  let!(:organization) { create(:organization) }
  let!(:measurement_type1) { create(:measurement_type, organization: organization) }
  let!(:measurement_type2) { create(:measurement_type, name: 'count', unit: 'number', organization: organization) }
  let!(:measurement_type3) { create(:measurement_type, name: 'gonad score', unit: 'number', organization: organization) }
  let!(:cohort) { create(:cohort, name: 'Test Cohort', organization: organization) }
  let(:file_with_spaces) { "#{Rails.root}/spec/fixtures/files/basic_custom_measurement_with_spaces.csv" }
  let(:file_without_spaces) { "#{Rails.root}/spec/fixtures/files/basic_custom_measurement.csv" }
  let(:expected_success_message) { 'Successfully queued spreadsheet for import' }
  let(:temporary_file) { create(:temporary_file, contents: File.read(valid_file)) }
  let(:measurements_comparison) do
    [
      {subject_type: "Cohort", measurement_type: "count", value: "24", measurement_event: "September Survey"},
      {subject_type: "Enclosure", measurement_type: "count", value: "42", measurement_event: "September Survey"},
      {subject_type: "Animal", measurement_type: "length", value: "14", measurement_event: "September Survey"},
      {subject_type: "Animal", measurement_type: "gonad score", value: "78", measurement_event: "September Survey"},
      {subject_type: "Animal", measurement_type: "length", value: "16", measurement_event: "September Survey"},
      {subject_type: "Animal", measurement_type: "gonad score", value: "46", measurement_event: "September Survey"}
    ]
  end

  before do
    sign_in user
    visit new_file_upload_path
  end

  context 'when user successfully uploads a CSV file with spaces in the header and values' do
    it "strips spaces and generates no errors" do
      expect do
        Measurement.delete_all
        upload_file("Measurement", [file_with_spaces])
      end.to change { ProcessedFile.count }.by(1)

      ProcessedFile.all.each do |processed_file|
        expect(processed_file.status).to eq "Processed"
        expect(processed_file.job_errors).to eq(nil)
        expect(processed_file.job_stats).to eq(
          {
            "row_count" => 6,
            "rows_imported" => 6,
            "shl_case_numbers" => {}
          }
        )
      end
      measurements = []
      Measurement.all.each do |measurement|
        measurements << {
          subject_type: measurement.subject_type,
          measurement_type: measurement.measurement_type.name,
          value: measurement.value,
          measurement_event: measurement.measurement_event.name
        }
      end
      expect(measurements).to eq(measurements_comparison)
      expect(page).to have_content expected_success_message
    end
  end
end
