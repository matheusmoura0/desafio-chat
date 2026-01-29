class UsersController < ApplicationController
    def index
        users = User.all.order(created_at: :desc)
        render json: UserSerializer.new(users).serializable_hash
    end
end