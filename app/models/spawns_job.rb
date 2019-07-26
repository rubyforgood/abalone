class SpawnsJob < ApplicationJob
  def perform(*args)
    filename = args[0]
    Rails.logger.info "!!!!!!!!!!!!!!!! Processing #{filename}"
  end
end