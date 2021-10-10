# frozen_string_literal: true

require 'rails_helper'

describe 'scheduler:delete_stale_temporary_files' do
  include_context 'rake'

  let(:temp_file) do
    create(:temporary_file, contents: '', created_at: 8.days.ago)
  end

  let!(:organization) { create(:organization) }

  it 'deletes a stale temporary file that is successfully processed' do
    create :processed_file, status: 'Processed', temporary_file_id: temp_file.id, organization_id: organization.id
    expect(TemporaryFile.count).to eq 1
    subject.invoke
    expect(TemporaryFile.count).to eq 0
  end

  it 'does not delete a recent temporary file' do
    file = create(:temporary_file, contents: '', created_at: 6.days.ago)
    create :processed_file, status: 'Processed', temporary_file_id: file.id, organization_id: organization.id
    subject.invoke
    expect(TemporaryFile.count).to eq 1
  end

  it 'warns about a temporary file that has no processed file' do
    temp_file
    subject.invoke
    expect(TemporaryFile.count).to eq 1
  end

  it 'warns about a temporary file that was not processed successfully' do
    create :processed_file, status: 'Failed', temporary_file_id: temp_file.id, organization_id: organization.id
    subject.invoke
    expect(TemporaryFile.count).to eq 1
  end
end
