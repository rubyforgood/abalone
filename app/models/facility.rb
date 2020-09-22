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
  has_many :tanks
  belongs_to :organization
  after_commit { Rails.cache.delete('facility_codes') }

  scope :for_organization, ->(organization) { where organization: organization }

  def self.valid_codes
    Rails.cache.fetch('facility_codes') do
      Facility.all.map { |facility| facility.code.upcase }
    end
  end

  def self.valid_code?(code)
    valid_codes.include?(code.upcase)
  end
end
