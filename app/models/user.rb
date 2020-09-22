class User < ApplicationRecord
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

  belongs_to :organization

  delegate :name, to: :organization, prefix: true, allow_nil: true
end
