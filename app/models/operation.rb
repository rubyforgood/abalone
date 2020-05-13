class Operation < ApplicationRecord
  belongs_to :tank

  belongs_to :operation_batch, required: false
  belongs_to :family, required: false

  validates :family, presence: true, if: :add_family?

  def perform
    case action.to_sym
    when :remove_family
      tank.update(family: nil)
    when :add_family
      tank.update(family: family)
    else
      raise InvalidActionError, action
    end
  end

  private

  def add_family?
    action&.to_sym == :add_family
  end

  class InvalidActionError < StandardError; end
end
