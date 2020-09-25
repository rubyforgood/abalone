class Location < ApplicationRecord
  include OrganizationScope

  belongs_to :facility
  has_many :enclosures

  validates :name, :facility_id, presence: true

  delegate :name, :code, to: :facility, prefix: true

  def name_with_facility
    "#{facility_name} - #{name}"
  end
end
