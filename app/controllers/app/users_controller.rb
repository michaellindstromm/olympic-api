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
                puts "hello #{@user.errors.messages}"
                if @user.errors.messages[:email]
                    flash[:alert] = "Email is already taken. Please try again."
                else 
                    flash[:alert] = "Please ensure your passwords match."
                end
                render :new
            end
        end

        def show
            @auth = false
        end
        
        def get_token
            puts params[:email]
            puts params[:password]
            command = AuthenticateUser.call(params[:user][:email], params[:user][:password])
            if command.success? 
                @auth = true
                @token = command.result
                render :show
            else    
                flash[:alert] = "Invalid credentials."
                render :show
            end
            
        end

        private
            def user_params
                params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation)
            end

    end
end