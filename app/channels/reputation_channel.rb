class ReputationChannel < ApplicationCable::Channel
  def subscribed
    stream_from "reputation_#{current_user.id}"
  end

  def unsubscribed
    stop_all_streams
  end
end
