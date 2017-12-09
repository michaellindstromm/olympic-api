module App
class HomeController < ApplicationController

    skip_before_action :authenticate_request
    
    def index

    end

    def show
        render json: {
            sports: 'https://olympicapi.herokuapp.com/api/sports',
            disciplines: 'https://olympicapi.herokuapp.com/api/disciplines',        
            events: 'https://olympicapi.herokuapp.com/api/events',        
            olympics: 'https://olympicapi.herokuapp.com/api/olympics',        
            countries: 'https://olympicapi.herokuapp.com/api/countries',        
            athletes: 'https://olympicapi.herokuapp.com/api/athletes',        
            medals: 'https://olympicapi.herokuapp.com/api/medals',
            token: 'https://olympicapi.herokuapp.com/api/authenticate'        
        }
    end

    private
        def home_params
            params.require(:home)
        end

end
end