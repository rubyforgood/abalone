# frozen_string_literal: true

class TemporaryFile < ApplicationRecord
  has_one :processed_file, inverse_of: :temporary_file
end
