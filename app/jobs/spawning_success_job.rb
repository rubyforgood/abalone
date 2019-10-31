class SpawningSuccessJob < ApplicationJob
  include ImportJob

  private

  def translate_attribute_names(attrs)
    attrs['nbr_of_eggs_spawned'] = attrs.delete('number_of_eggs_spawned_if_female')
    attrs
  end
end
