class Animal < ApplicationRecord
  include OrganizationScope
  include CsvExportable

  has_many :measurements, as: :subject
  has_many :animals_shl_numbers, dependent: :destroy
  has_many :shl_numbers, through: :animals_shl_numbers

  after_initialize :set_default_sex, if: :new_record?

  enum sex: {
    unknown: 'unknown',
    male: 'male',
    female: 'female'
  }

  def set_default_sex
    self.sex ||= :unknown
  end

  def shl_number_codes(join = ",")
    shl_numbers.pluck(:code).join(join)
  end
end
