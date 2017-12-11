class Api::V2::AthletesController < ApplicationController

    def index 
        athletes = Athlete.all.page(params[:page]).per(params[:per_page])

        render json: build_athletes(athletes)
    end

    def show
        athlete = Athlete.find(params[:id])
        
        render json: build_athlete(athlete)
    end

    private
        def athlete_params
            params.require(:athlete)
        end

        def build_athletes(athletes)
            obj = {}
            obj[:meta] = add_meta(athletes, 'athletes')
            obj[:results] = []

            athletes.each do |a|

                medals = []

                a.medals.each do |m|

                    e = Event.find(m.event_id)
                    d = e.discipline


                    medal_data = {
                        medal_id: m.id,
                        rank: m.rank,
                        event: m.event.event_name,
                        discipline: d.discipline_name,
                        season: m.olympic.season,
                        year: m.olympic.year,
                        represented_country: m.country.country_name
                    }

                    medals << medal_data
                end

                athlete_data = {
                    athlete_id: a.id,
                    first_name: a.first_name,
                    last_name: a.last_name,
                    gender: a.gender,
                    medals: medals
                }

                obj[:results] << athlete_data
            end

            obj
        end

        def build_athlete(a)

            obj = {}
            obj[:results] = {}

            medals = []

            a.medals.each do |m|

                e = Event.find(m.event_id)
                d = e.discipline


                medal_data = {
                    medal_id: m.id,
                    rank: m.rank,
                    event: m.event.event_name,
                    discipline: d.discipline_name,
                    season: m.olympic.season,
                    year: m.olympic.year,
                    represented_country: m.country.country_name
                }

                medals << medal_data
            end

            obj[:results][a.id] = {
                athlete_id: a.id,
                first_name: a.first_name,
                last_name: a.last_name,
                gender: a.gender,
                medals: medals
            }

            obj
        end
end
