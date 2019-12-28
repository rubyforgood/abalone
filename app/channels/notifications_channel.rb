class NotificationsChannel < ApplicationCable::Channel
  def subscribed
    stream_from "import_job:#{current_user.id}"
  end

  def unsubscribed
    stop_all_streams
  end
end
