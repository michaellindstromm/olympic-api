class Api::V2::EventsController < ApplicationController

    def index
        events = Event.all
        
        render json: event
    end

    def show
        event = Event.find(params[:id])

        render json: build_event(event)
    end

    private 
        def event_params
            params.require(:event)
        end

        def build_event(e)
            obj = {}
            obj[:results] = {}
            obj[:results][e.id] = {
                e.event_name
            }
            obj
        end
end
