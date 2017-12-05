module Api::V2
    class DisciplinesController < ApplicationController
        respond_to :json

        def index
            disciplines = Discipline.all.page(params[:page]).per(params[:per_page])

            render json: disciplines, meta: { pagination:
                                       { per_page: params[:per_page], 
                                         total_pages: disciplines.total_pages,
                                         total_objects: disciplines.total_count } }
        end

        def show
            discipline = Discipline.find(params[:id])

            render json: discipline
        end

        private
            def discipline_params
                params.require(:discipline)
            end
    end
end
