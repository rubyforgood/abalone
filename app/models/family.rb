class Family < ApplicationRecord
  belongs_to :male, class_name: 'Animal'
  belongs_to :female, class_name: 'Animal'
  belongs_to :organization

  has_many :measurements

  belongs_to :tank, required: false

  def female_pii_tag
    female.pii_tag
  end

  def male_pii_tag
    male.pii_tag
  end

  # def name
  # "Male: #{male.id} / Female: #{female.id}"
  # end
end
