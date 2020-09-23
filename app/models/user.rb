class User < ApplicationRecord
  include OrganizationScope

  enum role: %i[user admin]
  after_initialize :set_default_role, if: :new_record?

  def set_default_role
    self.role ||= :user
  end

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable,
  # :registerable, and :omniauthable
  devise :database_authenticatable, :recoverable,
         :rememberable, :validatable
end
