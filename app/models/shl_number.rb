class ShlNumber < ApplicationRecord
  has_many :animals_shl_numbers
  has_many :animals, through: :animals_shl_numbers
end
