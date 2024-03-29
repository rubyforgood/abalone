# rubocop:disable Lint/RedundantCopDisableDirective, Layout/LineLength
# == Schema Information
#
# Table name: facilities
#
#  id         :bigint           not null, primary key
#  name       :string
#  code       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# rubocop:enable Layout/LineLength, Lint/RedundantCopDisableDirective

class Facility < ApplicationRecord
  has_paper_trail

  include OrganizationScope
  include CsvExportable

  has_many :locations

  validates :name, presence: true
  validates :code, presence: true, uniqueness: { scope: :organization_id }

  after_commit { Rails.cache.delete('facility_codes') }

  def self.valid_codes
    Rails.cache.fetch('facility_codes') { pluck(:code).map(&:upcase) }
  end

  def self.valid_code?(code)
    valid_codes.include?(code.upcase)
  end

  # Replaced by blazer reporting - 1/24/21
  # ReportsKit uses this for default labeling
  def to_s
    code
  end
end
