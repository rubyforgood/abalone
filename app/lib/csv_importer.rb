module CsvImporter
  CSV_CATEGORIES = {
      SPAWNING_SUCCESS: 'Spawning Success',
      TAGGED_ANIMAL_ASSESSMENT: 'Tagged Animal Assessment',
      UNTAGGED_ANIMAL_ASSESSMENT: 'Untagged Animal Assessment'
  }.freeze

  class InvalidCsvCategoryError < StandardError; end;

  def self.import(filename, category_name)
    csv_category_model = model_from_category(category_name)
    IOStreams.each_record(filename) do |record|
      attrs = translate_attribute_names(record, category_name)
      spawning_success = csv_category_model.new(attrs.merge({raw: false}))
      spawning_success.cleanse_data! if spawning_success.respond_to?(:cleanse_data!)
      spawning_success.save
    end
  end

  def self.model_from_category(category_name)
    case category_name
    when CSV_CATEGORIES[:SPAWNING_SUCCESS]
      SpawningSuccess
    when CSV_CATEGORIES[:TAGGED_ANIMAL_ASSESSMENT]
      TaggedAnimalAssessment
    when CSV_CATEGORIES[:UNTAGGED_ANIMAL_ASSESSMENT]
      UntaggedAnimalAssessment
    else
      p category_name
      raise InvalidCsvCategoryError
    end
  end

  def self.translate_attribute_names(attrs, category_name)
    case category_name
    when CSV_CATEGORIES[:SPAWNING_SUCCESS]
      attrs['nbr_of_eggs_spawned'] = attrs.delete('number_of_eggs_spawned_if_female')
    end
    attrs
  end
end