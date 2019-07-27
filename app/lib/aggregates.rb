module Aggregates
  class Calculations

    # total number of animals in the program, by spawning date and holding facility
    # spawndate acts as the cohort designator here
    def self.total_animals_by_spawndate_and_facility(spawning_date, facility)
      PopulationEstimate.not_raw.where(facility: facility, spawning_date: spawning_date).pluck(:abundance).map(&:to_i).reduce(:+)
    end

    # spawning history of the broodstock (i.e., when we attempted to spawn them, were they successful in releasing gametes)
    def self.spawning_history(spawning_date, successful= %w[y Y])
      query = SpawningSuccess.not_raw.where(spawning_date: spawning_date, spawning_success: successful).group_by(&:date_attempted)
      query.each{ |k,v|  query[k] = v.map(&:spawning_success).count  }
    end

    # total egg, larval, or juvenile production by year (esp. how many year-old animals are produced annually)
    def self.offspring_production(life_stage, year)


    end

    # size distribution of animals within a population or within the entire captive breeding program
    def self.size_distribution(spawning_date= nil)
      query = TaggedAnimalAssessment.not_raw
      query = query.where(spawning_date: spawning_date) if spawning_date
      query.group(:length).count
    end

    # average growth rates of tagged individuals within populations or size classes over time
    def self.growth_rates(population)

    end

    # mortality within a cohort/population over time
    def self.deaths_by_cohort_for_date_range(cohort, date_range)
      query_results = MortalityTracking.not_raw.where(cohort: cohort, mortality_date: date_range ).group_by(&:mortality_date)
      query_results.each{|k,v| query_results[k] = v.map(&:number_morts).sum }
    end
  end
end
