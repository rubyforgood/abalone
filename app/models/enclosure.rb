class Enclosure < ApplicationRecord
  has_paper_trail

  include OrganizationScope
  include CsvExportable

  belongs_to :facility, optional: true
  has_many :operations, dependent: :destroy
  has_many :measurements, as: :subject

  has_one :cohort, required: false

  validates :name, uniqueness: { scope: %i[organization_id facility_id] }

  delegate :name, :code, to: :facility, prefix: true, allow_nil: true

  def self.exportable_columns
    column_names.reject { |col| %w[organization_id facility_id].include? col }.insert(2, 'facility_name')
  end

  def empty?
    cohort.blank?
  end
end
