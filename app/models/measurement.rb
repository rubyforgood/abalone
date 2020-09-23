class Measurement < ApplicationRecord
  include OrganizationScope

  belongs_to :measurement_event
  belongs_to :processed_file, optional: true
  belongs_to :animal, optional: true
  belongs_to :tank, optional: true
  belongs_to :family, optional: true

  HEADERS = {
    MEASUREMENT_EVENT: "measurement_event",
    MEASUREMENT: "measurement",
    VALUE: "value",
    TANK_NAME: "tank_name",
    ANIMAL_PII_TAG: "animal_pii_tag",
    FAMILY_NAME: "family_name"
  }.freeze

  # delegate :tank, to: :measurement_event
  def self.create_from_csv_data(attrs)
    # remove relational (non-attribute) data from hash to be handled separately
    measurement_event_name = attrs.fetch(:measurement_event)
    if attrs[:tank_name]
      tank = Tank.find_or_create_by!(
        name: attrs.fetch(:tank_name),
        organization_id: attrs.fetch(:organization_id)
      )
    end
    if attrs[:animal_pii_tag]
      animal = Animal.find_or_create_by!(
        pii_tag: attrs.fetch(:animal_pii_tag),
        organization_id: attrs.fetch(:organization_id)
      )
    end
    family = Family.find_by!(name: attrs.fetch(:family_name)) if attrs[:family_name]

    measurement_event = MeasurementEvent.find_or_create_by!(
      name: measurement_event_name,
      organization_id: attrs.fetch(:organization_id)
    )

    # create attributes for Measurement
    measurement_attrs = {}
    measurement_attrs[:measurement_event] = measurement_event
    measurement_attrs[:value] = attrs.fetch(:value)
    measurement_attrs[:name] = attrs.fetch(:measurement)
    measurement_attrs[:processed_file_id] = attrs.fetch(:processed_file_id)
    measurement_attrs[:organization_id] = attrs.fetch(:organization_id)
    measurement_attrs[:tank_id] = tank.id if tank
    measurement_attrs[:animal_id] = animal.id if animal
    measurement_attrs[:family_id] = family.id if family

    # create measurement
    Measurement.create!(measurement_attrs)

    ## TODO: allow attachment to any model, and attach measurement directly, not through the event
    ## this will require making a polymorphic "measurable"
    # klass = attrs.fetch(:entity).strip.classify.constantize # this only supports "tank" right now
    # name = attrs.fetch(:name)
    # model = klass.find_or_create_by!(name: name) # this will always be set to tank
    # model.measurements << measurement
  end
end
