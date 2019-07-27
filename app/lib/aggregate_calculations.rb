module Aggregates
  class Calculations
    def self.deaths_by_cohort_for_date_range(cohort, date_range)
      query_results = MortalityTracking.where(cohort: cohort, mortality_date: date_range ).group_by(&:mortality_date)
      query_results.each{|k,v| query_results[k] = v.map(&:number_morts).sum }
    end
  end
end
