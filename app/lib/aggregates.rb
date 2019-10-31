# frozen_string_literal: true

module Aggregates
  class Calculations
    # total number of animals in the program, by spawning date and holding facility
    # spawndate acts as the cohort designator here
    def self.total_animals_by_spawndate_and_facility(spawning_date, facility)
      PopulationEstimate.not_raw
                        .where(facility: facility, spawning_date: spawning_date)
                        .pluck(:abundance)
                        .map(&:to_i).reduce(:+)
    end

    # spawning history of the broodstock (i.e., when we attempted to spawn them, were they successful in releasing gametes)
    # => {date => n, date1 => n1, date2 => n2... }
    def self.spawning_history(spawning_date, successful = %w[y Y])
      query = SpawningSuccess.not_raw
                             .where(spawning_date: spawning_date, spawning_success: successful)
                             .group_by(&:date_attempted)

      query.each { |k, v| query[k] = v.map(&:spawning_success).count }
    end

    # total egg, larval, or juvenile production by year (esp. how many year-old animals are produced annually)
    def self.offspring_production(_life_stage, _year)
      # TODO
      {}
    end

    # size distribution of animals within a population or within the entire captive breeding program
    # => {l => c, l2 => c2, l3 => c3, ....}
    def self.size_distribution(spawning_date = nil)
      query = TaggedAnimalAssessment.not_raw
      query = query.where(spawning_date: spawning_date) if spawning_date
      query.group(:length).count
    end

    # average growth rates of tagged individuals within populations or size classes over time
    # => {tag => {date => n, date2 => n2} }
    def self.growth_rates(_date_range, tags, population = nil)
      query = TaggedAnimalAssessment.not_raw.where(tag: tags)
      query = query.where(tags: tags, spawning_date: population) if population
      return {} if query.empty?

      animal_growth = {}

      query.pluck(:tag).uniq.each do |tag|
        hash = query.where(tag: tag).group_by(&:measurement_date)
        # => {date => [record1, record2,...recordn]}
        count = 1 # for tracking rolling average

        hash.each_with_object(0) do |(k, val), rolling_sum|
          # calc rolling average
          # potential for innacurate calc if they have two measurements on the same day
          raise 'Two measurements for the same day' if val.count > 1

          val = val.first
          # the .to_f is to swap this from a less readable big decimal to something readable
          hash[k] = ((val.length + rolling_sum) / count.to_f).round(2).to_f
          # update tracking values for rolling avg
          count += 1
          rolling_sum += val.length
        end
        animal_growth[tag] = hash
      end

      animal_growth
    end

    # mortality within a cohort/population over time
    # => { date => death_count, death2 => death_count2,... }
    def self.deaths_by_cohort_for_date_range(cohort, date_range)
      query_results = MortalityTracking.not_raw
                                       .where(cohort: cohort, mortality_date: date_range)
                                       .group_by(&:mortality_date)

      query_results.each { |k, v| query_results[k] = v.map(&:number_morts).sum }
    end
  end
end
