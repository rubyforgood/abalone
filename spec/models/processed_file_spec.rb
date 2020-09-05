# rubocop:disable Lint/RedundantCopDisableDirective, Layout/LineLength
# == Schema Information
#
# Table name: processed_files
#
#  id                :bigint           not null, primary key
#  filename          :string
#  original_filename :string
#  category          :string
#  status            :string
#  job_stats         :jsonb            not null
#  job_errors        :text
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
# rubocop:enable Layout/LineLength, Lint/RedundantCopDisableDirective

require 'rails_helper'

RSpec.describe ProcessedFile, type: :model do
  it { should belong_to(:temporary_file).dependent(:destroy).optional }
end
