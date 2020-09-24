class Cohort < ApplicationRecord
  include OrganizationScope

  belongs_to :male, class_name: 'Animal', optional: true
  belongs_to :female, class_name: 'Animal', optional: true

  has_many :measurements, as: :subject
  has_many :animals

  belongs_to :enclosure, required: false

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
