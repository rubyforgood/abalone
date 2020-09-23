module Aggregates
  class Calculations
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
          raise "Two measurements for the same day" if val.count > 1

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
  end
end
