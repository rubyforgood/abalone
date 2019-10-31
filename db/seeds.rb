# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
facilities = { 'Aquarium of the Pacific' => 'AOP',
               'Cabrillo Marine Aquarium' => 'CMA',
               'California Science Center' => 'CSC',
               'CICESE' => 'CICESE',
               'Moss Landing Marine Laboratories' => 'MLML',
               'NOAA Southwest Fisheries Science Center' => 'SWFSC',
               'Santa Barbara Museum of Natural History Sea Center' => 'SBMNH SC',
               'The Abalone Farm' => 'TAF',
               'The Bay Foundation' => 'TBF',
               'The Cultured Abalone Farm' => 'TCAF',
               'UC Davis Bodega Marine Laboratory' => 'BML',
               'UC Santa Barbara' => 'UCSB' }

facilities.each { |f_name, f_code| Facility.find_or_create_by(name: f_name, code: f_code) }

# import all sample_data_files
Dir['db/sample_data_files/*'].each do |category_dir|
  category_class_name = File.basename(category_dir).titleize
  Dir["#{category_dir}/*.csv"].each_with_index do |filename, i|
    CsvImporter.import(filename, category_class_name, i + 1)
  end
end
