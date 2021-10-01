class ExitType < ApplicationRecord
  include OrganizationScope

  has_many :mortality_events

  validates :name, presence: true
end
