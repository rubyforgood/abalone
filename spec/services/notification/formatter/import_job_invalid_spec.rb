require 'rails_helper'

RSpec.describe Notification::Action::ImportJobInvalid do

  let(:instance) { described_class.new(data: data) }
  let(:data) {{
    headers: ["not valid header", "another not valid header", "header_1"],
    valid_headers: ["header_1", "header_2", "header_3"]
  }}

  describe "#deliver_message" do
    it 'broadcasts json data using ActionCable' do
      expect(ActionCable.server).to receive(:broadcast).with("import_job", {
        errors: ["not valid header", "another not valid header"],
        notification_title: "<strong>Error:</strong> <span>Invalid Headers:</span>",
        notification_type: "warning"
      })
      instance.deliver_message
    end
  end
end
