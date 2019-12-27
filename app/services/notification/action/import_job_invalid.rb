module Notification
  module Action
    class ImportJobInvalid

      CHANNEL_NAME = 'import_job'.freeze
      NOTIFICATION_TITLE = '<strong>Error:</strong> <span>Invalid Headers:</span>'.freeze
      NOTIFICATION_TYPE = 'warning'.freeze

      attr_reader :data

      def initialize(data:)
        @data = data
      end

      def deliver_message
        ActionCable.server.broadcast CHANNEL_NAME, { content: json_data }
      end

      private

      def json_data
        {
          invalid_headers: headers - valid_headers,
          valid_headers: valid_headers,
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

    end
  end
end
