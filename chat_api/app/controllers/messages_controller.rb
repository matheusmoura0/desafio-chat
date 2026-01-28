class MessagesController < ApplicationController
  before_action :authorize_request

  # GET /messages/:other_user_id?page=1
  def index
    other_user = User.find(params[:other_user_id])
    
    # Busca conversa
    messages = Message.where(sender: @current_user, receiver: other_user)
                      .or(Message.where(sender: other_user, receiver: @current_user))
                      .order(created_at: :desc) # Mais recentes primeiro para paginação funcionar bem
                      .page(params[:page]).per(10) # Kaminari: 10 por página

    # Serialização manual para incluir a URL do arquivo
    render json: {
      messages: messages.reverse.map { |msg| message_data(msg) }, # Inverte de volta para exibir cronológico
      meta: { current_page: messages.current_page, total_pages: messages.total_pages }
    }
  end

  # POST /messages
  def create
    message = Message.new(message_params.merge(sender: @current_user))
    
    if message.save
      render json: message_data(message), status: :created
    else
      render json: message.errors, status: :unprocessable_entity
    end
  end

  private

  def message_params
    params.permit(:content, :receiver_id, :file) # Permitir :file
  end

  def message_data(msg)
    {
      id: msg.id,
      content: msg.content,
      sender_id: msg.sender_id,
      file_url: msg.file.attached? ? url_for(msg.file) : nil,
      created_at: msg.created_at
    }
  end
end