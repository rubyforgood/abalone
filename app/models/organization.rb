class Organization < ApplicationRecord
  has_many :users
  has_many :families
  has_many :tanks
  has_many :measurements
  has_many :measurement_events
  has_many :operations
  has_many :facilities
  has_many :tanks, through: :facilities
  has_many :animals
end
