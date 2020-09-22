class Animal < ApplicationRecord
  include OrganizationScope

  enum sex: {
    male: 'male',
    female: 'female'
  }
  has_many :measurements
end
