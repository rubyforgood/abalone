require 'rails_helper'

RSpec.describe Notification::Action::ImportJobSuccess do

  let(:instance) { described_class.new(errors: ["Error message text"]) }

  describe "#deliver_message" do
    it 'broadcasts json data using ActionCable' do
      expect(ActionCable.server).to receive(:broadcast).with("import_job", {
        errors: ["Error message text"],
        notification_title: "Done!",
        notification_type: "success"
      })
      instance.deliver_message
    end
  end
end
