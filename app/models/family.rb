class Family < ApplicationRecord
  belongs_to :male, class_name: 'Animal'
  belongs_to :female, class_name: 'Animal'

  belongs_to :tank, required: false
end
