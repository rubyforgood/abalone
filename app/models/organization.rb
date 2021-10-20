class Organization < ApplicationRecord
  has_many :users
  has_many :cohorts
  has_many :enclosures
  has_many :measurements
  has_many :measurement_events
  has_many :operations
  has_many :facilities
  has_many :animals
  has_many :processed_files
end
