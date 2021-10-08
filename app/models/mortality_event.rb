class MortalityEvent < ApplicationRecord
  include OrganizationScope

  belongs_to :animal
  belongs_to :cohort
end
