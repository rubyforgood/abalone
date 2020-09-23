class Animal < ApplicationRecord
  include OrganizationScope

  enum sex: {
    unknown: 'unknown',
    male: 'male',
    female: 'female'
  }
  has_many :measurements
end
