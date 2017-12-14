class ApplicationController < ActionController::Base

    # Before all actions, unless explicitly specified all request 
    # must be authenticated with JWT. 

    # Only actions NOT requiring :authenticate_request
    # ***************************************************************
    # 1. app/home_controller#index to load documentation where devs
    # can sign up and recieve first JWT.
    # 
    # 2. app/users_controller where functionality to sign up is 
    # defined.
    # 
    # 3. authentication_controller where functionality to give first 
    # JWT is defined.

    def add_meta(results, controller) 
        obj = {
            pagination: {
                page: params[:page] ? params[:page].to_i : 1,
                per_page: params[:per_page] ? params[:per_page].to_i : 25, 
                total_pages: results.total_pages,
                total_objects: results.total_count 
            },
            links: {
                first: "https://olympicapi.herokuapp.com/api/" + "#{controller}" + "?page=1&per_page=" + "#{params[:per_page] ? params[:per_page].to_i : 25}",
                last: "https://olympicapi.herokuapp.com/api/" + "#{controller}" + "?page=" +  "#{results.total_pages}" + "&per_page=" + "#{params[:per_page] ? params[:per_page].to_i : 25}",
                next: ("https://olympicapi.herokuapp.com/api/" + "#{controller}" + "?page=" +  "#{params[:page] ? params[:page].to_i + 1 : 2}" + "&per_page=" + "#{params[:per_page] ? params[:per_page].to_i : 25}" if params[:page].to_i < results.total_pages),
                prev: ("https://olympicapi.herokuapp.com/api/" + "#{controller}" + "?page=" +  "#{params[:page].to_i - 1}" + "&per_page=" + "#{params[:per_page] ? params[:per_page].to_i : 25}" if params[:page].to_i > 1)
            }
        }
        obj
    end

    before_action :authenticate_request

    attr_reader :current_user

    private
        # This method is called before every request where
        # data is being transfered to end user. Which sets @current_user
        # as the JWT unless the user cannot be authenticated. To set
        # @current user the 'call' method is called from the 
        # AuthorizeApiRequest class defined in 
        # 'app/commands/authorize_api_request.rb'. The method call passes
        # the request headers as arguments to the 'call' method and if 
        # successful returns the result, which will be the JWT.

        def authenticate_request
            @current_user = AuthorizeApiRequest.call(request.headers).result
            render json: { error: 'Not Authorized' }, status: 401 unless @current_user
        end
    
end
