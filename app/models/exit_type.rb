class ExitType < ApplicationRecord
  include OrganizationScope

  has_many :mortality_events, dependent: :restrict_with_error

  validates :name, presence: true
end
