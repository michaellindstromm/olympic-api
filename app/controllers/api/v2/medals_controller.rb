class Api::V2::MedalsController < ApplicationController

    def index 
        medals = Medal.all.page(params[:page]).per(params[:per_page])

        render json: build_medals(medals)
    end

    def show
        medal = Medal.find(params[:id])

        render json: build_medal(medal)
    end

    private
        def medal_params
            params.require(:medal)
        end

        def build_medals(medals)
            obj = {}
            obj[:meta] = add_meta(medals, 'medals')
            obj[:results] = []

            medals.each do |m|
                ath = Athlete.find(m.athlete_id)
                full_name = ath.last_name + ', ' + ath.first_name
                olympics = Olympic.find(m.olympic_id)
                city = City.find(olympics.city_id)
                
                medal_data = {
                    medal_id: m.id,
                    rank: m.rank,
                    athlete: full_name,
                    event: Event.find(m.event_id).event_name,
                    year: olympics.year,
                    olympic_city: city.city_name,
                    represented_country_id: m.country.id,
                    represented_country: m.country.country_name
                }
                obj[:results] << medal_data
            end

            obj
        end

        def build_medal(m)
            obj = {}
            obj[:results] = {}
            ath = Athlete.find(m.athlete_id)
            full_name = ath.last_name + ', ' + ath.first_name
            olympics = Olympic.find(m.olympic_id)
            city = City.find(olympics.city_id)
            obj[:results][m.id] = {
                
                 
                    medal_id: m.id,
                    rank: m.rank,
                    athlete: full_name,
                    event: Event.find(m.event_id).event_name,
                    year: olympics.year,
                    olympic_city: city.city_name,
                    represented_country: m.country.country_name
                
            }
            obj
        end
end
