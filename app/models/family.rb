class Family < ApplicationRecord
  has_one :male, class_name: :animal
  has_one :female, class_name: :animal

end
