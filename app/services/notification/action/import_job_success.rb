module Notification
  module Action
    class ImportJobSuccess

      CHANNEL_NAME = 'import_job'.freeze
      NOTIFICATION_TITLE = 'Done!'.freeze
      NOTIFICATION_TYPE = 'success'.freeze

      attr_reader :data

      def initialize(data: {})
        @data = data
      end

      def deliver_message
        ActionCable.server.broadcast CHANNEL_NAME, { content: json_data }
      end

      private

      def json_data
        {
          notification_title: NOTIFICATION_TITLE,
          notification_type: NOTIFICATION_TYPE
        }.merge(data)
      end

    end
  end
end
