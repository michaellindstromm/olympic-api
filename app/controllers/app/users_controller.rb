module App
class UsersController < ApplicationController

    skip_before_action :authenticate_request

    def new
    end

    def create
        user = User.new(user_params)
        if user.save
            command = AuthenticateUser.call(user.email, user.password)
            render json: { auth_token: command.result, expiration_in: 7200}
        else
            redirect_to :sign_up_path
        end
    end

    def show
        
    end

    private
        def user_params
            params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation)
        end
end
end