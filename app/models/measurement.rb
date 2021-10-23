class Measurement < ApplicationRecord
  include OrganizationScope

  belongs_to :measurement_event
  belongs_to :processed_file, optional: true
  belongs_to :subject, polymorphic: true
  belongs_to :measurement_type

  validates :subject_type, presence: true, inclusion: { in: %w(Cohort Enclosure Animal) }
  validates :value, presence: true

  delegate :name, to: :measurement_type, prefix: true, allow_nil: true
  delegate :name, to: :measurement_event, prefix: true, allow_nil: true

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

  def cohort_name
    subject.is_a?(Cohort) ? subject.name : nil
  end

  def enclosure_name
    subject.is_a?(Enclosure) ? subject.name : nil
  end

  def animal_tag
    subject.is_a?(Animal) ? subject.tag : nil
  end

  # We want mortality events to be created as part of measurement file uploads, which means that if a measurement
  # file is uploaded and it has mortality events, we want to show that data as well
  def self.data_for_file(processed_file_id)
    where(processed_file_id: processed_file_id) + MortalityEvent.where(processed_file_id: processed_file_id)
  end

  def display_data
    [
      date, subject_type, measurement_type_name, value, measurement_event_name, enclosure_name, cohort_name, animal_tag, nil
    ]
  end

  # The below code is unstable. This is retrofitting the values from the seeded CSV
  # In reality, for instance, the subject would not always be a enclosure
  def self.create_from_csv_data(attrs)
    # remove relational (non-attribute) data from hash to be handled separately
    measurement_event_name = attrs.fetch(:measurement_event)
    enclosure = Enclosure.find_or_create_by(
      name: attrs.fetch(:enclosure_name),
      organization_id: attrs.fetch(:organization_id)
    )

    measurement_type = MeasurementType.find_by(name: attrs.fetch(:measurement_type), organization_id: attrs.fetch(:organization_id))

    measurement_event = MeasurementEvent.find_or_create_by(
      name: measurement_event_name,
      organization_id: attrs.fetch(:organization_id)
    )

    type = attrs.fetch(:subject_type)
    case type.downcase
    when 'animal'
      subject = Animal.find_or_create_by(tag: attrs.fetch(:tag), organization_id: attrs.fetch(:organization_id))
    when 'cohort'
      subject = Cohort.find_by(name: attrs.fetch(:cohort_name), organization_id: attrs.fetch(:organization_id))
    when 'enclosure'
      subject = enclosure
    end

    # create attributes for Measurement
    measurement_attrs = {}
    measurement_attrs[:date] = attrs.fetch(:date)
    measurement_attrs[:measurement_event] = measurement_event
    measurement_attrs[:value] = attrs.fetch(:value)
    measurement_attrs[:subject_type] = attrs.fetch(:subject_type)
    measurement_attrs[:processed_file_id] = attrs.fetch(:processed_file_id)
    measurement_attrs[:organization_id] = attrs.fetch(:organization_id)
    measurement_attrs[:subject] = subject
    measurement_attrs[:measurement_type] = measurement_type

    # create measurement
    Measurement.create(measurement_attrs)

    ## TODO: allow attachment to any model, and attach measurement directly, not through the event
    ## this will require making a polymorphic "measurable"
    # klass = attrs.fetch(:entity).strip.classify.constantize # this only supports "enclosure" right now
    # name = attrs.fetch(:name)
    # model = klass.find_or_create_by!(name: name) # this will always be set to enclosure
    # model.measurements << measurement
  end
end
