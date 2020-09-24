class Enclosure < ApplicationRecord
  include OrganizationScope

  belongs_to :facility, optional: true
  has_many :operations, dependent: :destroy
  has_many :post_settlement_inventories
  has_many :measurements, as: :subject

  has_one :cohort, required: false

  validates :name, uniqueness: { scope: %i[organization_id facility_id] }

  delegate :name, to: :facility, prefix: true, allow_nil: true

  def empty?
    cohort.blank?
  end
end
