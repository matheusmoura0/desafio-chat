class ApplicationController < ActionController::API
  def authorize_request
    header = request.headers['Authorization']
    token = header.split(' ').last if header
    begin
      decoded = JWT.decode(token, 'SEGREDO_SUPER_SECRETO')[0]
      @current_user = User.find(decoded['user_id'])
    rescue
      render json: { errors: 'Acesso negado' }, status: :unauthorized
    end
  end
end