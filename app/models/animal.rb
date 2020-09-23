class Animal < ApplicationRecord
  include OrganizationScope

  after_initialize :set_default_sex, if: :new_record?

  enum sex: {
    unknown: 'unknown',
    male: 'male',
    female: 'female'
  }
  has_many :measurements

  def set_default_sex
    self.sex ||= :unknown
  end
end
