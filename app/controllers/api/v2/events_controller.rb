class Api::V2::EventsController < ApplicationController

    def index
        events = Event.all.page(params[:page]).per(params[:per_page])
        
        render json: build_events(events)
    end

    def show
        event = Event.find(params[:id])

        render json: build_event(event)
    end

    private 
        def event_params
            params.require(:event)
        end

        def build_events(events)
            obj = {}
            obj[:meta] = add_meta(events, 'events')
            obj[:results] = []
            events.each do |e|

                olympics = []

                e.olympics.group(:id).order(:year).each do |o|
                    olympic_data = {
                        olympic_id: o.id,
                        season: o.season,
                        year: o.year
                    }
                    olympics << olympic_data
                end

                event_data = {
                    event_id: e.id,
                    event_name: e.event_name,
                    discipline_name: e.discipline.discipline_name,
                    olympics: olympics
                }

                obj[:results] << event_data
            end

            obj
        end

        def build_event(e)
            olympics = []

            e.olympics.group(:id).order(:year).each do |o|
                olympic_data = {
                    olympic_id: o.id,
                    season: o.season,
                    year: o.year
                }
                olympics << olympic_data
            end

            obj = {}
            obj[:results] = {}
            obj[:results][e.id] = {
                event_id: e.id,
                event_name: e.event_name,
                discipline_name: e.discipline.discipline_name,
                olympics: olympics
            }
            obj
        end
end
