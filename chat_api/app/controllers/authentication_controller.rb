class AuthenticationController < ApplicationController
  def login
    @user = User.find_by(username: params[:username])
    if @user&.authenticate(params[:password])
      token = JWT.encode({ user_id: @user.id }, 'SEGREDO_SUPER_SECRETO')
      render json: { token: token, user: { id: @user.id, username: @user.username } }
    else
      render json: { error: 'Unauthorized' }, status: :unauthorized
    end
  end
end