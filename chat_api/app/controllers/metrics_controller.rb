class MetricsController < ApplicationController
  before_action :authorize_request 

  def index
    render json: {
      total_users: User.count,
      total_messages: Message.count,
      active_users_24h: User.where('updated_at > ?', 24.hours.ago).count # Exemplo
    }
  end
end