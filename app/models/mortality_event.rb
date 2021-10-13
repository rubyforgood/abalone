class MortalityEvent < ApplicationRecord
  include OrganizationScope

  belongs_to :animal, optional: true
  belongs_to :cohort

  def self.create_from_csv_data(attrs)
    if attrs[:measurement_type] == 'animal mortality event'
      animal_attrs = self.attrs_for_animal(attrs)
      self.create(animal_attrs)
    else
      cohort_attrs = self.attrs_for_cohort(attrs)
      self.create(cohort_attrs)
    end
  end

private

  def self.attrs_for_animal(attrs)
    measurement_attrs = {}
    measurement_attrs[:mortality_date] = attrs.fetch(:mortality_date)
    measurement_attrs[:animal] = Animal.find_or_create_by!(tag: attrs.fetch(:tag), organization_id: attrs.fetch(:organization_id))
    measurement_attrs[:cohort] = Cohort.find_by!(name: attrs.fetch(:cohort_name), organization_id: attrs.fetch(:organization_id))
    measurement_attrs[:organization_id] = attrs.fetch(:organization_id)
    # TODO: what is exit type?
    measurement_attrs
  end

  def self.attrs_for_cohort(attrs)
    measurement_attrs = {}
    measurement_attrs[:mortality_date] = attrs.fetch(:mortality_date)
    measurement_attrs[:cohort] = Cohort.find_by!(name: attrs.fetch(:cohort_name), organization_id: attrs.fetch(:organization_id))
    measurement_attrs[:mortality_count] = attrs.fetch(:value)
    measurement_attrs[:organization_id] = attrs.fetch(:organization_id)
    # TODO: what is exit type?
    measurement_attrs
  end
end
