class ExitType < ApplicationRecord
  include OrganizationScope
  scope :enabled, -> { where(disabled: [false, nil]) }
  scope :disabled, -> { where(disabled: true) }

  validates :name, presence: true
end
