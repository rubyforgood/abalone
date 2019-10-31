# frozen_string_literal: true

require 'rails_helper'

shared_examples_for 'import job' do
  before(:each) do
    FileUtils.cp(
      Rails.root.join('db', 'sample_data_files', 'tagged_animal_assessment', filename),
      Rails.root.join('storage')
    )
  end

  after(:each) do
    if File.exist?(Rails.root.join('storage', filename))
      File.delete(Rails.root.join('storage', filename))
    end
  end

  let(:filename) { 'Tagged_assessment_12172018 (original).csv' }
  let(:perform_job) { described_class.perform_now(filename) }

  it 'saves ProcessedFile' do
    expect { perform_job }.to change { ProcessedFile.count }.by 1
    expect(ProcessedFile.last.filename).to eq(filename)
  end

  describe '#validate_headers' do
    it 'returns true for valid headers' do
      validate_headers = described_class.new.validate_headers(
        Rails.root.join('storage', filename).to_s
      )

      expect(validate_headers).to eq(true)
    end

    it 'returns false for invalid headers' do
      validate_headers = described_class.new.validate_headers(
        Rails.root.join('spec', 'support', 'csv', 'invalid_headers.csv').to_s
      )

      expect(validate_headers).to eq(false)
    end
  end

  describe '#import_records' do
    it 'imports record into db' do
      processed_file = create(:processed_file)
      instance = described_class.new
      record_count_before = instance.category.constantize.count
      instance.processed_file = processed_file

      expect do
        instance.import_records(
          Rails.root.join('storage', filename).to_s
        )
      end.to change { instance.category.constantize.count }

      record_count_after = instance.category.constantize.count

      expect(
        record_count_before < record_count_after
      ).to eq(true)
    end
  end
end
