class Api::V2::OlympicsController < ApplicationController
    def index
        olympics = Olympic.all.page(params[:page]).per(params[:per_page])
        
        render json: build_olympics(olympics)
    end

    def show
        olympic = Olympic.find(params[:id])

        render json: build_olympic(olympic)
    end

    private
        def olympic_params
            params.require(:olympic)
        end

        def build_olympics(olympics)
            obj = {}
            obj[:meta] = add_meta(olympics, 'olympics')
            obj[:results] = []
            olympics.each do |o|

                events = []

                o.events.group(:id).each do |e|
                    event_data = {
                        event_id: e.id,
                        event_name: e.event_name,
                        discipline: e.discipline.discipline_name
                    }
                    events << event_data
                end


                olympic_data = {
                    olympic_id: o.id,
                    year: o.year,
                    season: o.season,
                    city: o.city.city_name,
                    country: o.country.country_name,
                    events: events
                }

                obj[:results] << olympic_data
            end
            obj
        end

        def build_olympic(o)
            obj = {}
            obj[:results] = {}

            events = []

            o.events.group(:id).each do |e|
                event_data = {
                    event_id: e.id,
                    event_name: e.event_name,
                    discipline: e.discipline.discipline_name
                }
                events << event_data
            end

            obj[:results][o.id] = {
                olympic_id: o.id,
                year: o.year,
                season: o.season,
                city: o.city.city_name,
                country: o.country.country_name,
                events: events
            }
        end
end
