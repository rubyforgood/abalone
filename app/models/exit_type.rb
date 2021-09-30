class ExitType < ApplicationRecord
  include OrganizationScope

  validates :name, presence: true
end
