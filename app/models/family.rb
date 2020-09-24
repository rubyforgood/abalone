class Family < ApplicationRecord
  has_paper_trail

  include OrganizationScope

  belongs_to :male, class_name: 'Animal', optional: true
  belongs_to :female, class_name: 'Animal', optional: true

  has_many :measurements, as: :subject

  belongs_to :tank, required: false

  delegate :pii_tag, to: :female, prefix: true, allow_nil: true
  delegate :pii_tag, to: :male, prefix: true, allow_nil: true

  # def name
  # "Male: #{male.id} / Female: #{female.id}"
  # end
end
