class MortalityEvent < ApplicationRecord
  belongs_to :animal
  belongs_to :cohort
end
