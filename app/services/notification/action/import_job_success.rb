module Notification
  module Action
    class ImportJobSuccess

      NOTIFICATION_TITLE = 'Done!'.freeze
      NOTIFICATION_TYPE = 'success'.freeze

      attr_reader :data, :errors

      def initialize(data: {}, errors: [])
        @data = data
        @errors = errors
      end

      def deliver_message(channel_name)
        ActionCable.server.broadcast channel_name, json_data
      end

      private

      def json_data
        {
          notification_title: NOTIFICATION_TITLE,
          notification_type: NOTIFICATION_TYPE,
          errors: errors
        }.merge(data)
      end

    end
  end
end
