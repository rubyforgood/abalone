# frozen_string_literal: true

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

class ProcessedFile < ApplicationRecord
  include OrganizationScope

  belongs_to :temporary_file,
             optional: true,
             inverse_of: :processed_file,
             dependent: :destroy
  belongs_to :organization

  validates :job_stats, exclusion: { in: [nil, ""] }

  after_initialize :set_default_job_stats, if: :new_record?

  private

  def set_default_job_stats
    self.job_stats = {}
  end
end
