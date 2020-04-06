# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
User.create({ email: "admin@test.com",
              password: "password",
              password_confirmation: "password" })

facilities= { "Aquarium of the Pacific" => "AOP",
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

facilities.each { |f_name, f_code| Facility.find_or_create_by(name: f_name, code: f_code) }

# import all sample_data_files (uncomment when importers are added for all CSV categories)
# Dir["db/sample_data_files/*"].each do |category_dir|
#   category_class_name = File.basename(category_dir).titleize
#   Dir["#{category_dir}/*.csv"].each_with_index do |filename, i|
#     CsvImporter.new(filename, category_class_name, i+1).call
#   end
# end

current_csv_importers = CsvImporter::CATEGORIES

Dir["db/sample_data_files/*"].each do |category_dir|
  category_class_name = File.basename(category_dir).titleize
  if current_csv_importers.include?(category_class_name)
    Dir["#{category_dir}/*.csv"].each_with_index do |filename, i|
      CsvImporter.new(filename, category_class_name, i + 1).call
    end
  end
end

# Tanks can have Operations occur (add or remove animals, combine tank contents, etc)
# Tanks can also have Measurements (number of animals, temperature of tank, etc)
male = Animal.create(sex: 'male')
female = Animal.create(sex: 'female')
family = Family.create(male: male, female: female)
tank = Tank.create(facility: Facility.find_by(code: 'PSRF'), name: 'AB-17')
Operation.create(tank: tank, animals_added: 800, animals_added_family_id: family.id, operation_date: 7.days.ago, operation_type: 'add')
Measurement.create(name: 'count', value_type: 'integer', value: '743', tank: tank, date: 3.days.ago)
Measurement.create(name: 'count', value_type: 'integer', value: '719', tank: tank, date: 1.days.ago)
