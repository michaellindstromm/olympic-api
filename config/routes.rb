# ***********************************************************************
# ***********************************************************************

# Sets the routes to access defined end points and controlls versioning. 

# The documentation home page is scoped to the 'home' controller defined 
# in the 'app' subdirectory and no extra path is necessary.
# 
# API endpoints are scoped under the 'api' subdirectory with the default
# format set to JSON. Under the 'api' subdirectory are each of the
# version subdirectories entitled ('v1', 'v2', etc). Paths for both API 
# and specific versions are removed so end user only has to put '/sports'
# instead of '/api/v1/sports' for example. Constraints are defined for 
# each version in order to give the user the correctly serialized JSON
# for the requested version. If no version is requested, the default
# is set to most up to date version. (Note: users are strongly encouraged
# to explicitly set the version requested, otherwise when new versions 
# are released, their app may break due to a change in data
# serialization). Version constraints are handled in the ApiConstraints
# class defined in 'lib/api_constraints.rb'.

# ***********************************************************************
# ***********************************************************************

require 'api_constraints.rb'

OlympicApi::Application.routes.draw do

  scope module: :app, path: '/' do
    root 'home#index'

    get 'sign_up', to: 'users#new'
    post 'first_token', to: 'users#create'
    get 'api/endpoints', to: 'home#show'
  end

  post 'api/authenticate', to: 'authentication#authenticate'
  scope module: :api, defaults: { format: :json }, path: 'api' do
    scope module: :v1, as: 'v1', path: '/' do
      constraints(ApiConstraints.new({version: 1})) do
        resources :sports, :only => [:index, :show]
        resources :olympics, :only => [:index, :show]
      end
    end

    scope module: :v2, as: 'v2', path: '/'  do
      constraints(ApiConstraints.new({version: 2, default: true})) do
        resources :sports, :only => [:index, :show]
        resources :olympics, :only => [:index, :show]
        resources :countries, :only => [:index, :show]
      end
    end
  end

end
