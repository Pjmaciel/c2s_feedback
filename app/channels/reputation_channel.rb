class ReputationChannel < ApplicationCable::Channel
  def subscribed
    stream_from "reputation_#{params[:user_id]}"
  end

  def unsubscribed
    # Limpeza ao sair do canal
  end
end
