# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

white_abalone = Organization.create(name: "White Abalone")
pinto_abalone = Organization.create(name: "Pinto Abalone")

User.create({ :email => "test@example.com",
              :password => "password",
              :password_confirmation => "password",
              :organization => white_abalone,
              :role => :user }
              )

User.create({ :email => "admin@whiteabalone.com",
              :password => "password",
              :password_confirmation => "password",
              :organization_id => white_abalone.id,
              :role => :admin }
              )

User.create({ :email => "admin@pintoabalone.com",
              :password => "password",
              :password_confirmation => "password",
              :organization_id => pinto_abalone.id,
              :role => :admin }
              )

white_abalone_facilities= { "Aquarium of the Pacific" => "AOP",
              "Cabrillo Marine Aquarium" => "CMA",
              "California Science Center" => "CSC",
              "CICESE" => "CICESE",
              "Moss Landing Marine Laboratories" => "MLML",
              "NOAA Southwest Fisheries Science Center" => "SWFSC",
              "Santa Barbara Museum of Natural History Sea Center" => "SBMNH SC",
              "The Abalone Farm" => "TAF",
              "The Bay Foundation" => "TBF",
              "The Cultured Abalone Farm" => "TCAF",
              "UC Davis Bodega Marine Laboratory" => "BML",
              "UC Santa Barbara" =>"UCSB",
              "Puget Sound Restoration Fund" => "PSRF",
            }

white_abalone_facilities.each do |f_name, f_code|
  facility = Facility.find_or_create_by(name: f_name, code: f_code, organization_id: white_abalone.id)
  Tank.find_or_create_by(name: "Tank", facility: facility, organization: white_abalone)
end

Facility.create(name: "Pinto Abalone Facility", code: "TBD", organization_id: pinto_abalone.id)
# import all sample_data_files (uncomment when importers are added for all CSV categories)
# Dir["db/sample_data_files/*"].each do |category_dir|
#   category_class_name = File.basename(category_dir).titleize
#   Dir["#{category_dir}/*.csv"].each_with_index do |filename, i|
#     CsvImporter.new(filename, category_class_name, i + 1, white_abalone).call
#   end
# end

current_csv_importers = CsvImporter::CATEGORIES

Dir["db/sample_data_files/*"].each do |category_dir|
  category_class_name = File.basename(category_dir).titleize
  if current_csv_importers.include?(category_class_name)
    Dir["#{category_dir}/*.csv"].each_with_index do |filename, i|
      CsvImporter.new(filename, category_class_name, i + 1, white_abalone).call
    end
  end
end

# Tanks can have Operations occur (add or remove animals, combine tank contents, etc)
# Tanks can also have Measurements (number of animals, temperature of tank, etc)
male = Animal.create!(sex: 'male', organization_id: white_abalone.id)
female = Animal.create!(sex: 'female', organization_id: pinto_abalone.id)
family = Family.create!(male: male, female: female, organization_id: white_abalone.id)
tank = Tank.create!(facility: Facility.find_by(code: 'PSRF'), name: 'AB-17', organization_id: white_abalone.id)
Operation.create!(tank: tank, animals_added: 800, family: family, operation_date: 7.days.ago, action: :add_family, organization_id: white_abalone.id)
measurement_event = MeasurementEvent.create!(name: "My first measurement", organization_id: white_abalone.id)
measurement_type = MeasurementType.create!(name: "length", unit: "cm", organization: white_abalone)
Measurement.create!(value: '743', measurement_event: measurement_event, date: 3.days.ago, organization_id: white_abalone.id, subject: male, measurement_type: measurement_type)
Measurement.create!(value: '719', measurement_event: measurement_event, date: 1.days.ago, organization_id: white_abalone.id, subject: female, measurement_type: measurement_type)
