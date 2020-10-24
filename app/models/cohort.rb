class Cohort < ApplicationRecord
  has_paper_trail

  include OrganizationScope
  include CsvExportable

  belongs_to :male, class_name: 'Animal', optional: true
  belongs_to :female, class_name: 'Animal', optional: true

  has_many :animals
  has_many :measurements, as: :subject
  has_many :mortality_events

  belongs_to :enclosure, required: false

  delegate :name, to: :enclosure, prefix: true, allow_nil: true

  def self.exportable_columns
    %w[id name female_tag male_tag enclosure_name created_at updated_at]
  end

  delegate :tag, to: :female, prefix: true, allow_nil: true
  delegate :tag, to: :male, prefix: true, allow_nil: true

  def to_s
    name.blank? ? "Cohort #{id}" : name
  end

  def mortality_count
    mortality_events.count
  end

  # def name
  # "Male: #{male.id} / Female: #{female.id}"
  # end
end
