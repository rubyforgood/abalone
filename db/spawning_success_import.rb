# frozen_string_literal: true

filename = 'spawn_newheaders.xlsx'
filename = Rails.root.join(filename).to_s

def translate_attribute_names(attrs)
  attrs['nbr_of_eggs_spawned'] = attrs.delete('number_of_eggs_spawned_if_female')
  attrs
end

puts "SpawningSuccess.count=#{SpawningSuccess.count}"
IOStreams.each_record(filename) do |record|
  attrs = translate_attribute_names(record)
  spawning_success = SpawningSuccess.new(attrs.merge(raw: false))
  spawning_success.cleanse_data!
  spawning_success.save
end
puts "SpawningSuccess.count=#{SpawningSuccess.count}"
