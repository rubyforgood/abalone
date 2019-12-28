module Notification
  module Action
    class ImportJobInvalid

      NOTIFICATION_TITLE = '<strong>Error:</strong> <span>Invalid Headers:</span>'.freeze
      NOTIFICATION_TYPE = 'warning'.freeze

      attr_reader :data

      def initialize(data:)
        @data = data
      end

      def deliver_message(channel_name)
        ActionCable.server.broadcast channel_name, json_data
      end

      private

      def json_data
        {
          errors: invalid_headers,
          notification_title: NOTIFICATION_TITLE,
          notification_type: NOTIFICATION_TYPE
        }
      end

      def headers
        data[:headers]
      end

      def valid_headers
        data[:valid_headers]
      end

      def invalid_headers
        headers - valid_headers
      end

    end
  end
end
