class Location < ApplicationRecord
  include OrganizationScope

  belongs_to :facility

  validates :name, :facility_id, presence: true
end
