module Notification
  module Formatter
    class ImportJob

      CHANNEL_NAME = 'import_job'.freeze

      attr_reader :data, :type

      def initialize(data:, notification_type: :error)
        @data = data
        @notification_type = notification_type
      end

      def deliver_message
        ActionCable.server.broadcast CHANNEL_NAME, { html: output_html }
      end

      private

      def output_html
        "<div class='notification is-warning'>
          <button class='delete'></button>
          <strong>Invalid headers</strong>
          <p>Valid headers: #{valid_headers.join(', ')}</p>
          <p>Current headers: #{headers.join(', ')}</p>
        </div>"
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
