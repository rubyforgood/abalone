class ReportBuilder
  attr_accessor :cohort, :date

  def initialize(date:, cohort:)
    @cohort = cohort
    @date = date
  end

  def cohort_options
    build_cohort_options(date: @date)
  end

  def measurement_date_options
    build_date_options(cohort: @cohort)
  end

  # Uses the cohort and measurement date instance variables to try and find 
  # a corresponding processed file. For now just returns the first id to work
  # with the existing javascript code. This will probably need to be changed.
  def processed_file_id
    assessment = find_animal_assessments(cohort: @cohort, date: @date)&.first
    assessment&.processed_file_id
  end

  private

  # Reads in a (maybe)measurement date and returns all possible 
  # animal assessment shl_case_numbers that correspond to it. 
  #
  # TODO: Add UntaggedAnimalAssessment lookup
  def build_cohort_options(date:)
    if date
      find_animal_assessments(date: date, cohort: nil).pluck(:shl_case_number).uniq
    else
      TaggedAnimalAssessment.pluck(:shl_case_number).uniq #+ UntaggedAnimalAssessment.pluck(:cohort)).uniq
    end
  end

  # Reads in a (maybe)cohort and returns all possible 
  # animal assessment measurement_dates that correspond to it. 
  #
  # TODO: Add UntaggedAnimalAssessment lookup
  def build_date_options(cohort:)
    if cohort
      find_animal_assessments(cohort: cohort, date: nil).pluck(:measurement_date).uniq
    else
      TaggedAnimalAssessment.pluck(:measurement_date).uniq # + UntaggedAnimalAssessment.pluck(:measurement_date)).uniq
    end
  end

  # Reads in a (maybe)cohort and a (maybe)measurement date, and tries to find
  # all possible animal assessments that correspond to it. 
  #
  # TODO: Add UntaggedAnimalAssessment lookup
  # TODO: Is there a cleaner way to code this to avoid the nil checks?
  def find_animal_assessments(cohort:, date:)
    if cohort and date and TaggedAnimalAssessment.exists?(shl_case_number: cohort, measurement_date: date)
      TaggedAnimalAssessment.where(shl_case_number: cohort, measurement_date: date)
    elsif cohort and TaggedAnimalAssessment.exists?(shl_case_number: cohort)
      TaggedAnimalAssessment.where(shl_case_number: cohort)
    elsif date and TaggedAnimalAssessment.exists?(measurement_date: date)
      TaggedAnimalAssessment.where(measurement_date: date)
    end
  end
end
