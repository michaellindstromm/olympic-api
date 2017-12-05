module Api::V1
    class SportsController < ApplicationController
        respond_to :json

        def index
            sports = Sport.all.page(params[:page]).per(params[:per_page])

            render json: sports, meta: { pagination:
                                       { per_page: params[:per_page], 
                                         total_pages: sports.total_pages,
                                         total_objects: sports.total_count } }
        end

        def show
            sport = Sport.find(params[:id])

            render json: sport
        end

        private
            def sport_params
                params.require(:sport)
            end

    end
end
