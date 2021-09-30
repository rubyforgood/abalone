class ExitType < ApplicationRecord
  include OrganizationScope
  scope :enabled, -> { where(disabled: [false, nil]) }
  scope :disabled, -> { where(disabled: true) }

  has_many :mortality_events

  validates :name, presence: true
end
