class UsersController < ApplicationController
    before_action :authorize, only: [:show]
    # skip_before_action :authorize, only: [:show]

    def show
        render json: current_user
    end

    def create
        user = User.create(user_params)
        if user.valid?
            session[:user_id] = user.id
            render json: user, status: :created
        else
            render json: { error: user.errors.full_messages }, status: :unprocessable_entity
        end
    end

    
    private

    def user_params
        params.permit(:username, :password, :password_cornfirmation)
    end


    def authorize
        head :unauthorized unless current_user
    end

    def current_user
        @current_user ||= User.find_by(id: session[:user_id])
    end

end