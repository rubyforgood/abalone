class Operation < ApplicationRecord
  include OrganizationScope

  belongs_to :enclosure

  belongs_to :operation_batch, required: false
  belongs_to :cohort, required: false

  validates :cohort, presence: true, if: :add_cohort?

  def perform
    case action.to_sym
    when :remove_cohort
      enclosure.update(cohort: nil)
    when :add_cohort
      enclosure.update(cohort: cohort)
    else
      raise InvalidActionError, action
    end
  end

  private

  def add_cohort?
    action&.to_sym == :add_cohort
  end

  class InvalidActionError < StandardError; end
end
