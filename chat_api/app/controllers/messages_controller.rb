class MessagesController < ApplicationController
  before_action :authorize_request

  # GET /messages/:other_user_id?page=1
  def index
    other_user = User.find(params[:other_user_id])
    
    messages = Message.where(sender: @current_user, receiver: other_user)
                      .or(Message.where(sender: other_user, receiver: @current_user))
                      .order(created_at: :desc)
                      .page(params[:page]).per(10)

    options = {
      meta: { current_page: messages.current_page, total_pages: messages.total_pages }
    }
    render json: MessageSerializer.new(messages.reverse, options).serializable_hash
  end

  # POST /messages
  def create
    message = Message.new(message_params.merge(sender: @current_user))
    
    if message.save
      render json: MessageSerializer.new(message).serializable_hash, status: :created
    else
      render json: message.errors, status: :unprocessable_entity
    end
  end

  private

  def message_params
    params.permit(:content, :receiver_id, :file) # Permitir :file
  end
end