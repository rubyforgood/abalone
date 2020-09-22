class Animal < ApplicationRecord
  enum sex: {
    male: 'male',
    female: 'female'
  }

  has_many :measurements
end
