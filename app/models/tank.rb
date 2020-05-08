class Tank < ApplicationRecord
  belongs_to :facility, optional: true
  has_many :post_settlement_inventories
  has_many :measurement_events
  has_many :measurements, through: :measurement_events

  has_one :family, required: false
end
