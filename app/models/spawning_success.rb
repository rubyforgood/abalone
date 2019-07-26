class SpawningSuccess < ApplicationRecord
  HEADERS = %w[
    Tag
    SHL_number
    Spawning_date
    Date_attempted
    Spawning_success
    Number of eggs spawned
  ]
  enum spawning_success: [ :did_not_spawn, :spawned_few_gametes, :spawned_lots ]

  def spawning_success=(success_code)
    case success_code
    when "n"
      @spawning_success = :did_not_spawn
    when "y"
      @spawning_success = :spawned_few_gametes
    when "Y"
      @spawning_success = :spawned_lots
    end
  end
end
