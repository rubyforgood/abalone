module Notification
  class Broadcaster

    attr_reader :channel_name

    def initialize(action, channel_name)
      @action = action
      @channel_name = channel_name
    end

    def deliver_message
      @action.deliver_message(channel_name)
    end
  end
end
