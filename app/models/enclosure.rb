class Enclosure < ApplicationRecord
  include OrganizationScope

  belongs_to :location, optional: true
  has_many :operations, dependent: :destroy
  has_many :measurements, as: :subject

  has_one :cohort, required: false

  validates :name, uniqueness: { scope: %i[organization_id location_id] }

  delegate :name, to: :location, prefix: true, allow_nil: true
  delegate :facility_name, to: :location, allow_nil: true

  def empty?
    cohort.blank?
  end
end
