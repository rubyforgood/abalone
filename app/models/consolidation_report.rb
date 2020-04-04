class ConsolidationReport < ApplicationRecord
  belongs_to :family
  belongs_to :tank_from, class_name: :tank
  belongs_to :tank_to, class_name: :tank
end
