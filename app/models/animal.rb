class Animal < ApplicationRecord
  include OrganizationScope

  belongs_to :cohort, optional: true
  has_many :measurements, as: :subject

  after_initialize :set_default_sex, if: :new_record?

  enum sex: {
    unknown: 'unknown',
    male: 'male',
    female: 'female'
  }

  def set_default_sex
    self.sex ||= :unknown
  end
end
