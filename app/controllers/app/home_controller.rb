module App
class HomeController < ApplicationController

    skip_before_action :authenticate_request
    
    def index

    end

    private
        def home_params
            params.require(:home)
        end

end
end