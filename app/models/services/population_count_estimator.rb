class PopulationCountEstimator
  def self.run(shl_number, date)
    new(shl_number, date).run
  end

  def initialize(shl_number, date)
    @shl_number = shl_number
    @date = date
  end

  def run
    
  end

  private

  attr_reader :shl_number, :date


end
