class ConsolidationReport < ApplicationRecord
  belongs_to :family
  belongs_to :tank_from, classname: :tank
  belongs_to :tank_to, classname: :tank
end
