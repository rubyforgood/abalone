# rubocop:disable Lint/UnneededCopDisableDirective, Metrics/LineLength
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
# rubocop:enable Metrics/LineLength, Lint/UnneededCopDisableDirective

class Facility < ApplicationRecord
  after_commit { Rails.cache.delete('facility_codes') }

  def self.valid_codes
    Rails.cache.fetch('facility_codes') do
      Facility.all.map { |facility| facility.code.upcase }
    end
  end

  def self.valid_code?(code)
    valid_codes.include?(code.upcase)
  end
end
