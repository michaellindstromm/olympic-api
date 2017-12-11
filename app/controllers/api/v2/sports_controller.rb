module Api::V2
    class SportsController < ApplicationController
        respond_to :json

        def index
            sports = Sport.all.page(params[:page]).per(params[:per_page])
            render json: build_sports(sports)
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
                obj[:meta] = add_meta(sports, 'sports')
                obj[:results] = []

                sports.each do |s|
                    disciplines = []

                    s.disciplines.order(:discipline_name).each do |d|
                        discipline_data = {
                            discipline_id: d.id,
                            discipline_name: d.discipline_name
                        }
                        disciplines << discipline_data
                    end

                    sports_data = {
                        sport_id: s.id,
                        sport_name: s.sport_name,
                        disciplines: disciplines
                    }  
                    obj[:results] << sports_data
                end

                obj
            end

            def build_sport(sport)
                obj = {}
                disciplines = {}

                sport.disciplines.order(:discipline_name).each do |d|
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
