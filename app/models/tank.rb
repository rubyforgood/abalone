class Tank < ApplicationRecord
  belongs_to :facility
  has_many :post_settlement_inventories
end
