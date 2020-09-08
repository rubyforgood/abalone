class Family < ApplicationRecord
  belongs_to :male, class_name: 'Animal'
  belongs_to :female, class_name: 'Animal'
  has_many :measurements

  belongs_to :tank, required: false

  # def name
  # "Male: #{male.id} / Female: #{female.id}"
  # end
end
