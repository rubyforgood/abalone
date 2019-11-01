class NotificationsChannel < ApplicationCable::Channel
  def subscribed
    stream_from "import_job"
  end

  def unsubscribed
    stop_all_streams
  end
end
