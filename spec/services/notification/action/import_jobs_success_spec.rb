require 'rails_helper'

RSpec.describe Notification::Action::ImportJobSuccess do

  let(:instance) { described_class.new(errors: ["Error message text"]) }

  describe "#deliver_message" do
    it 'broadcasts json data using ActionCable' do
      expect(ActionCable.server).to receive(:broadcast).with("channel:user_id", {
        errors: ["Error message text"],
        notification_title: "Done!",
        notification_type: "success"
      })
      instance.deliver_message("channel:user_id")
    end
  end
end
