module Services
  class PopulationCountEstimator
    def self.run(shl_case_number, date)
      new(shl_case_number, date).run
    end

    def initialize(shl_case_number, date)
      @shl_case_number = shl_case_number
      @date = date
    end

    def run
      population_count - number_of_mortalities
    end

    private

    attr_reader :shl_case_number, :date

    def population_count
      population_estimate.abundance
    end

    def population_estimate_date
      population_estimate.sample_date
    end

    def population_estimate
      @population_estimate ||=
        PopulationEstimate.where(shl_case_number: shl_case_number)
                          .where('sample_date <= ?', date)
                          .order(sample_date: :desc)
                          .first
    end

    def number_of_mortalities
      MortalityTracking.where(shl_case_number: shl_case_number)
                       .where('mortality_date >= ?', population_estimate_date)
                       .sum(&:number_morts)
    end
  end
end
