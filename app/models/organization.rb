class Organization < ApplicationRecord
  has_many :users
  has_many :families
  has_many :tanks
  has_many :facilities
  has_many :tanks, through: :facilities
  has_many :animals
end
