class UntaggedAnimalAssessmentJob < ApplicationJob

  include ImportJob

  def translate_attribute_names(attrs)
    attrs['shl_case_number'] = attrs.delete('cohort')
    attrs
  end

end
