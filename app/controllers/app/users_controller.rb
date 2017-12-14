module App
    class UsersController < ApplicationController

        skip_before_action :authenticate_request

        def new
            @user = User.new
        end

        def create
            @user = User.new(user_params)
            if @user.save
                command = AuthenticateUser.call(@user.email, @user.password)
                redirect_to token_url
            else
                flash[:alert] = "Please ensure your passwords match."
                render :new
            end
        end


        private
            def user_params
                params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation)
            end

            def show
                
            end
    end
end