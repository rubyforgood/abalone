class User < ApplicationRecord
  include OrganizationScope

  enum role: %i[user admin]
  after_initialize :set_default_role, if: :new_record?

  def set_default_role
    self.role ||= :user
  end

  # Track the logged-in user at the model level
  # so that we can leverage the user's organization
  # within blazer reporting.
  def self.current
    Thread.current[:user]
  end

  def self.current=(user)
    Thread.current[:user] = user
  end

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable,
  # :registerable, and :omniauthable
  devise :database_authenticatable, :recoverable,
         :rememberable, :validatable
end
