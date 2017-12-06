module Api::V1
    class OlympicsController < ApplicationController

        def index
            olympics = Olympic.all.page(params[:page], params[:per_page])

            render json: build_json(olympics), meta: {pagination:
                                                     { 

                                                     }}
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
                obj[:meta] = {
                "pagination": {
                    "page": params[:page].to_i,
                    "per_page": params[:per_page].to_i ? params[:per_page] : 25, 
                    "total_pages": sports.total_pages,
                    "total_objects": sports.total_count 
                }
            }
            obj["results"] = {}
            
            end
    end     
end