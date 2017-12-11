module Api::V2
    class DisciplinesController < ApplicationController
        respond_to :json

        def index
            disciplines = Discipline.all.page(params[:page]).per(params[:per_page])

            render json: build_disciplines(disciplines)
        end

        def show
            discipline = Discipline.find(params[:id])

            render json: build_discipline(discipline)
        end

        private
            def discipline_params
                params.require(:discipline)
            end

            def build_disciplines(disciplines)
                obj = {}
                obj[:meta] = add_meta(disciplines, 'disciplines')
                obj[:results] = []
                
                disciplines.each do |d|
                    events = []

                    d.events.each do |e|
                        event_data = {
                            event_id: e.id,
                            event_name: e.event_name,
                            gender: e.gender
                        }

                        events << event_data
                    end

                    discipline_data = {
                        discipline_id: d.id,
                        discipline_name: d.discipline_name,
                        sport_name: d.sport.sport_name,
                        events: events
                    }

                    obj[:results] << discipline_data
                end

                obj
            end

            def build_discipline(d)
                obj = {}
                obj[:results] = {}

                events = []

                d.events.order(:event_name).each do |e|
                    event_data = {
                        event_id: e.id,
                        event_name: e.event_name,
                        gender: e.gender
                    }

                    events << event_data
                end

                obj[:results][d.id] = {
                    discipline_id: d.id,
                    discipline_name: d.discipline_name,
                    sport_name: d.sport.sport_name,
                    events: events
                }

                obj
            end
    end
end
