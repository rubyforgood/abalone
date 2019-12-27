module Notification
  class Broadcaster
    def initialize(formatter)
      @formatter = formatter
    end

    def deliver_message
      @formatter.deliver_message
    end
  end
end
