class Api::V2::OlympicsController < ApplicationController
    def index
        olympics = Olympic.all.page(params[:page]).per(params[:per_page])
        
        render json: build_json(olympics), meta: { pagination:
                                       { page: params[:page].to_i ? params[:page] : olympics.page,
                                         per_page: params[:per_page].to_i ? params[:per_page] : 25, 
                                         total_pages: olympics.total_pages,
                                         total_objects: olympics.total_count } }
    end

    def show
        olympic = Olympic.find(params[:id])

        render json: olympic
    end

    private
        def olympic_params
            params.require(:olympic)
        end

        def build_json(olympics)
            olympics
        end
end
