class ConsolidationReport < ApplicationRecord
  belongs_to :family
  belongs_to :tank_from, class_name: 'Tank'
  belongs_to :tank_to, class_name: 'Tank'
end
