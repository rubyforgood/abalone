class Animal < ApplicationRecord
  include OrganizationScope

  has_many :measurements, as: :subject
end
