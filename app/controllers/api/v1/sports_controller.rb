module Api::V1
    class SportsController < ApplicationController
        respond_to :json

        def index
            sports = Sport.all.page(params[:page]).per(params[:per_page])
            obj = {}
            obj[:meta] = {
                "pagination": {
                    "page": params[:page],
                    # "per_page": sports.per(), 
                    "total_pages": sports.total_pages,
                    "total_objects": sports.total_count 
                }
            }
            obj["results"] = {}
            sports.each do |s|

                disciplines = {}

                s.disciplines.each do |d|
                    disciplines[d.id] = {
                        discipline_id: d.id,
                        discipline_name: d.discipline_name
                    }
                end

                obj["results"][s.id] = {
                    sport_id: s.id,
                    sport_name: s.sport_name,
                    disciplines: disciplines
                }
            end
            render json: obj, meta: { pagination:
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
