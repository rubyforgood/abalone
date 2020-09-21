class Animal < ApplicationRecord
  include OrganizationScope

  has_many :measurements
end
