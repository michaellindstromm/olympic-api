class AuthenticationController < ApplicationController
    skip_before_action :authenticate_request

    # The 'authenticate' method is used to create a new JWT for a signed up user.
    # A POST method which returns the encoded JWT if the user's credentials
    # are correct by validating a successful call with an http status of 2xx. 
    # This request is skips the 'authenticate_request' method, because either the 
    # user is a first time user and does not have a JWT, or the user's current JWT 
    # has expired and the user is requesting a new JWT. The 'authenticate' method 
    # calls the 'call' method in the AuthenticateUser class defined in 
    # 'app/commands/authenticate_user.rb'. It passes the supplied email and password
    # as arguments.


    def authenticate
        command = AuthenticateUser.call(params[:email], params[:password])

        if command.success?
            render json: { auth_token: command.result, expiration_in: 86400 }
        else
            render json: { error: command.errors }, status: :unauthorized
        end
    end
end