class Tank < ApplicationRecord
  include OrganizationScope

  belongs_to :facility, optional: true
  has_many :operations, dependent: :destroy
  has_many :post_settlement_inventories
  has_many :measurements, as: :subject

  has_one :family, required: false

  validates :name, uniqueness: { scope: :organization }

  delegate :name, to: :facility, prefix: true, allow_nil: true

  def empty?
    family.blank?
  end
end
