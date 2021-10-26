require "rails_helper"

shared_examples_for "import job" do
  let(:local_sample_data_filepath) { Rails.root.join("db", "sample_data_files", described_class.category.underscore, filename) }
  let(:sample_csv_text) { File.read(local_sample_data_filepath, encoding: 'bom|utf-8') }
  let(:temporary_file) { create(:temporary_file, contents: sample_csv_text) }
  let(:perform_job) { described_class.perform_now(temporary_file, filename, organization) }

  before do
    create(:cohort, name: "Adams Family") if described_class.is_a? MeasurementJob
  end

  it "saves ProcessedFile" do
    expect { perform_job }.to change { ProcessedFile.count }.by 1
    expect(ProcessedFile.last.temporary_file_id).to eq(temporary_file.id)
  end

  describe "#validate_headers" do
    it "returns true for valid headers" do
      validate_headers = described_class.new.validate_headers(temporary_file)

      expect(validate_headers).to eq(true)
    end

    it "returns false for invalid headers" do
      invalid_headers_sample_data_filepath = Rails.root.join("spec", "support", "csv", "invalid_headers.csv")
      invalid_headers_sample_csv_text = File.read(invalid_headers_sample_data_filepath, encoding: 'bom|utf-8')
      invalid_headers_temporary_file = create(:temporary_file, contents: invalid_headers_sample_csv_text)
      validate_headers = described_class.new.validate_headers(invalid_headers_temporary_file)

      expect(validate_headers).to eq(false)
    end

    it "set the error message" do
      instance = described_class.new

      invalid_headers_sample_data_filepath = Rails.root.join("spec", "support", "csv", "invalid_headers.csv")
      invalid_headers_sample_csv_text = File.read(invalid_headers_sample_data_filepath, encoding: 'bom|utf-8')
      invalid_headers_temporary_file = create(:temporary_file, contents: invalid_headers_sample_csv_text)

      instance.perform(invalid_headers_temporary_file, "invalid_headers.csv", organization)

      expect(ProcessedFile.last.temporary_file_id).to eq(invalid_headers_temporary_file.id)
      expect(ProcessedFile.last.job_errors).to eq("Does not have valid header(s). Data not imported!")
    end
  end

  it "imports record into db" do
    instance = described_class.new
    record_count_before = instance.category.constantize.count

    expect { instance.perform(temporary_file, filename, organization) }.to change { instance.category.constantize.count }

    record_count_after = instance.category.constantize.count
    expect(
      record_count_before < record_count_after
    ).to eq(true)
  end
end
