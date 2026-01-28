class UsersController < ApplicationController
    def index
        users = User.all.order(created_at: :desc)
        render json: users, each_serializer: UserSerializer
    end
end