class MortalityEvent < ApplicationRecord
  include OrganizationScope

  belongs_to :animal, optional: true
  belongs_to :cohort
  belongs_to :exit_type, optional: true
  belongs_to :processed_file, optional: true

  HEADERS = [
    "Date",
    "Subject Type",
    "Measurement Type",
    "Value",
    "Measurement Event",
    "Enclosure Name",
    "Cohort Name",
    "Tag",
    "Reason"
  ].freeze

  def display_data
    [
      mortality_date, mortality_type, "mortality event", mortality_count, nil, cohort.enclosure&.name, cohort.name, animal&.tag, exit_type&.name
    ]
  end

  def self.create_from_csv_data(attrs)
    if attrs[:measurement_type] == "animal mortality event"
      animal_attrs = attrs_for_animal(attrs)
      create(animal_attrs)
    else
      cohort_attrs = attrs_for_cohort(attrs)
      create(cohort_attrs)
    end
  end

  def self.attrs_for_animal(attrs)
    measurement_attrs = {}
    measurement_attrs[:mortality_date] = attrs.fetch(:date)
    measurement_attrs[:animal] = Animal.find_or_create_by(tag: attrs.fetch(:tag), organization_id: attrs.fetch(:organization_id))
    measurement_attrs[:cohort] = Cohort.find_by(name: attrs.fetch(:cohort_name), organization_id: attrs.fetch(:organization_id))
    measurement_attrs[:organization_id] = attrs.fetch(:organization_id)
    measurement_attrs[:exit_type] = ExitType.find_by(name: attrs.fetch(:reason), organization_id: attrs.fetch(:organization_id))
    measurement_attrs[:processed_file_id] = attrs.fetch(:processed_file_id)
    measurement_attrs
  end

  def self.attrs_for_cohort(attrs)
    measurement_attrs = {}
    measurement_attrs[:mortality_date] = attrs.fetch(:date)
    measurement_attrs[:cohort] = Cohort.find_by(name: attrs.fetch(:cohort_name), organization_id: attrs.fetch(:organization_id))
    measurement_attrs[:mortality_count] = attrs.fetch(:value)
    measurement_attrs[:organization_id] = attrs.fetch(:organization_id)
    measurement_attrs[:exit_type] = ExitType.find_by(name: attrs.fetch(:reason), organization_id: attrs.fetch(:organization_id))
    measurement_attrs[:processed_file_id] = attrs.fetch(:processed_file_id)
    measurement_attrs
  end

  private

  private_class_method :attrs_for_animal, :attrs_for_cohort

  def mortality_type
    !animal && mortality_count ? "Cohort" : "Animal"
  end
end
