module Api::V2
    class SportsController < ApplicationController
        respond_to :json

        def index
            sports = Sport.all.page(params[:page]).per(params[:per_page])

            render json: build_sports(sports), meta: { pagination:
                                       { page: params[:page].to_i,
                                         per_page: params[:per_page].to_i ? params[:per_page] : 25, 
                                         total_pages: sports.total_pages,
                                         total_objects: sports.total_count } }

        end

        def show
            sport = Sport.find(params[:id])

            render json: build_sport(sport)
        end

        private
            def sport_params
                params.require(:sport)
            end

            def build_sports(sports) 
                obj = {}
                obj[:meta] = {
                    "pagination": {
                        "page": params[:page].to_i,
                        "per_page": params[:per_page].to_i ? params[:per_page] : 25, 
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
                obj
            end

            def build_sport(sport)
                obj = {}
                disciplines = {}

                sport.disciplines.each do |d|
                    disciplines[d.id] = {
                            discipline_id: d.id,
                            discipline_name: d.discipline_name
                        }
                end

                obj[sport.id] = {
                    sport_id: sport.id,
                    sport_name: sport.sport_name,
                    disciplines: disciplines
                }

                obj
            end
    end
end
