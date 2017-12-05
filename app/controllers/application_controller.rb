class ApplicationController < ActionController::Base

    # Before all actions, unless explicitly specified
    # all request must be authenticated with JWT.
    # Only actions not requiring :authenticate_request
    # - app/home#index to load documentation where

    before_action :authenticate_request

    attr_reader :current_user

    private
        # This method is called before every request where
        # data is being transfered to end user. Except

        def authenticate_request
            @current_user = AuthorizeApiRequest.call(request.headers).result
            render json: { error: 'Not Authorized' }, status: 401 unless @current_user
        end
    
end
