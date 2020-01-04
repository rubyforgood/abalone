class WildCollectionJob < ApplicationJob
  include ImportJob

  private

  # Translate from csv column name to database column name
  def translate_attribute_names(attrs)
    attrs['proximity_to_nearest_neighbor']              = attrs.delete('proximity_to_nearest_neighbor_m')
    attrs['collection_depth']                           = attrs.delete('collection_depth_m')
    attrs['collection_coordinates']                     = attrs.delete('collection_coodinates')
    attrs['final_holding_facility_and_date_of_arrival'] = attrs.delete('final_holding_facility__date_of_arrival')

    attrs
  end

  def preprocess_attribute_values(attrs)
    attrs['collection_date'] = Date.strptime(attrs['collection_date'], '%m/%d/%y') rescue nil
    attrs['otc_treatment_completion_date'] = Date.strptime(attrs['otc_treatment_completion_date'], '%m/%d/%y') rescue nil

    attrs
  end
end
