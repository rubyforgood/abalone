# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# This seed file is to be used for development purposes only!

return unless Rails.env.development? || Rails.env.test?

organization_entities = {
    organizations: [
        {
            name: 'White Abalone',
            facilities: [
                { name: 'Aquarium of the Pacific', code: 'AOP' },
                { name: 'Cabrillo Marine Aquarium', code: 'CMA' },
                { name: 'California Science Center', code: 'CSC' },
                { name: 'CICESE', code: 'CICESE' },
                { name: 'Moss Landing Marine Laboratories', code: 'MLML' },
                { name: 'NOAA Southwest Fisheries Science Center', code: 'SWFSC' },
                { name: 'Santa Barbara Museum of Natural History Sea Center', code: 'SBMNH SC' },
                { name: 'The Abalone Farm', code: 'TAF' },
                { name: 'The Bay Foundation', code: 'TBF' },
                { name: 'The Cultured Abalone Farm', code: 'TCAF' },
                { name: 'UC Davis Bodega Marine Laboratory', code: 'BML' },
                { name: 'UC Santa Barbara', code: 'UCSB' },
            ]
        },
        {
            name: 'Pinto Abalone',
            facilities: [
                { name: 'Chew Center of Shellfish Research and Restoration', code: 'CCSRR' },
                { name: 'NOAA Manchester Research Station', code: 'NMARS' },
                { name: 'NOAA Mukilteo Research Station', code: 'NMURS' },
                { name: 'Port Madison Community Shellfish Farm', code: 'PMCSF' },
                { name: 'Puget Sound Restoration Fund', code: 'PSRF' },
                { name: 'Washington Department of Fish & Wildlife', code: 'WDFW' }
            ]

        }
    ]
}

organization_entities[:organizations].each do |org_ent|
  # Create organization
  org = Organization.find_or_create_by(name: org_ent[:name])

  # Create users
  User.create(
    email: "user@#{org.name.downcase.gsub(/\W/, '')}.com",
    password: 'password',
    password_confirmation: 'password',
    organization: org,
    role: :user
  )
  User.create(
    email: "admin@#{org.name.downcase.gsub(/\W/, '')}.com",
    password: 'password',
    password_confirmation: 'password',
    organization: org,
    role: :admin
  )

  # Populate reference tables
  # Create measurement types - these can be organizationally specific
  MeasurementType.find_or_create_by(name: 'length', unit: 'cm', organization: org)
  MeasurementType.find_or_create_by(name: 'count', unit: 'number', organization: org)
  MeasurementType.find_or_create_by(name: 'weight', unit: 'g', organization: org)
  MeasurementType.find_or_create_by(name: 'gonad score', unit: 'number', organization: org)

  # Create facilities and their associated locations and enclosures
  org_ent[:facilities].each do |fac_ent|
    facility = Facility.find_or_create_by(name: fac_ent[:name], code: fac_ent[:code], organization: org)
    location = Location.find_or_create_by(name: "#{fac_ent[:name]} location", facility: facility, organization: org)
    enclosure = Enclosure.find_or_create_by(name: "#{location.name} enclosure", location: location, organization: org)

    # Create animals and a cohort per facility
    cohort = Cohort.find_or_create_by(name: "#{enclosure.name} cohort", enclosure: enclosure, organization: org)

    male = Animal.find_or_create_by(
      sex: :male,
      collection_year: Time.zone.now.year,
      date_time_collected: Time.zone.now,
      collection_position: 'Position',
      cohort: cohort,
      tag: "M-#{fac_ent[:code]}",
      organization: org
    )
    male_shl = ShlNumber.find_or_create_by(code: "#{male.collection_year}-#{male.tag}")
    AnimalsShlNumber.find_or_create_by(animal: male, shl_number: male_shl)

    female = Animal.find_or_create_by(
      sex: :female,
      collection_year: Time.zone.now.year,
      date_time_collected: Time.zone.now,
      collection_position: 'Position',
      cohort: cohort,
      tag: "F-#{fac_ent[:code]}",
      organization: org
    )
    female_shl = ShlNumber.find_or_create_by(code: "#{female.collection_year}-#{female.tag}")
    AnimalsShlNumber.find_or_create_by(animal: female, shl_number: female_shl)

    cohort.update(male: male, female: female)

    8.times do |n|
      animal = Animal.find_or_create_by(
                sex: n.even? ? :female : :male,
                collection_year: Time.zone.now.year,
                date_time_collected: Time.zone.now,
                collection_position: 'Position',
                tag: "#{n+1}-#{fac_ent[:code]}",
                cohort: cohort,
                organization: org
              )
      animal_shl = ShlNumber.find_or_create_by(code: "#{animal.collection_year}-#{animal.tag}")
      AnimalsShlNumber.find_or_create_by(animal: animal, shl_number: animal_shl)
    end

    # Create an operation batch and operation
    operation_batch = OperationBatch.find_or_create_by(name: "#{enclosure.name} operation batch")
    Operation.find_or_create_by(
      operation_batch: operation_batch,
      enclosure: enclosure,
      animals_added: 10,
      cohort: cohort,
      operation_date: 1.day.ago,
      action: :add_cohort,
      organization: org
    )

    # Create a measurement event
    event = MeasurementEvent.find_or_create_by(name: "#{fac_ent[:name]} september survey", organization: org)

    # Create measurements for animals
    MeasurementType.all.each do |mt|
      if mt.name == 'count'
        # Create count measurements
        Measurement.find_or_create_by(
          value: 10,
          measurement_event: event,
          date: 1.day.ago,
          subject: cohort,
          measurement_type: mt,
          organization: org
        )
        Measurement.find_or_create_by(
          value: 10,
          measurement_event: event,
          date: 1.day.ago,
          subject: enclosure,
          measurement_type: mt,
          organization: org
        )
      else
        # Create animal measurements
        Measurement.find_or_create_by(
          value: '3',
          measurement_event: event,
          date: 1.day.ago,
          subject: male,
          measurement_type: mt,
          organization: org
        )
        Measurement.find_or_create_by(
          value: '3',
          measurement_event: event,
          date: 1.day.ago,
          subject: female,
          measurement_type: mt,
          organization: org
        )
      end
    end
  end
end
