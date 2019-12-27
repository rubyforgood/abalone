module Notification
  module Formatter
    class ImportJob

      CHANNEL_NAME = 'import_job'.freeze

      attr_reader :data, :notification_type

      def initialize(data:, notification_type: 'warning')
        @data = data
        @notification_type = notification_type
      end

      def deliver_message
        ActionCable.server.broadcast CHANNEL_NAME, { content: json_data }
      end

      private

      def json_data
        {
          invalid_headers: headers - valid_headers,
          valid_headers: valid_headers,
          notification_type: notification_type
        }
      end

      def headers
        data[:headers]
      end

      def valid_headers
        data[:valid_headers]
      end

    end
  end
end
