class Organization < ApplicationRecord
    has_many :users
    has_many :facilities
    has_many :tanks, through: :facilities
end
