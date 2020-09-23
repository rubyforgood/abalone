class Tank < ApplicationRecord
  include OrganizationScope

  belongs_to :facility, optional: true
  has_many :operations, dependent: :destroy
  has_many :measurements, as: :subject

  has_one :family, required: false

  validates :name, uniqueness: { scope: %i[organization_id facility_id] }

  delegate :name, to: :facility, prefix: true, allow_nil: true

  def empty?
    family.blank?
  end
end
