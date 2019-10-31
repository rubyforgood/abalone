# frozen_string_literal: true

module Raw
  extend ActiveSupport::Concern

  included do
    scope :raw, -> { where(raw: true) }
    scope :not_raw, -> { where(raw: false) }
  end
end
