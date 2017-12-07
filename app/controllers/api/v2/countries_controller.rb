class Api::V2::CountriesController < ApplicationController

    def index
        countries = Country.all.page(params[:page]).per(params[:per_page])

        render json: build_countries(countries), meta: { pagination:
                                       { page: params[:page].to_i ? params[:page] : countries.page,
                                         per_page: params[:per_page].to_i ? params[:per_page] : 25, 
                                         total_pages: countries.total_pages,
                                         total_objects: countries.total_count } }
    end

    def show
        country = Country.find(params[:id])

        render json: build_country(country)
    end

    private
        def countries_params
            params.require(:country)
        end

        def build_countries(countries)
            obj = {}

            obj[:meta] = {
                    "pagination": {
                        "page": params[:page].to_i,
                        "per_page": params[:per_page].to_i ? params[:per_page] : 25, 
                        "total_pages": countries.total_pages,
                        "total_objects": countries.total_count 
                    }
                }

            obj["results"] = {}

            countries.each do |c|

                olympics = {}

                c.olympics.each do |o|
                    olympics[o.id] = {
                        "olympic_id": o.id,
                        "year": o.year,
                        "season": o.season,
                        "city": o.city.city_name
                    }
                end

                obj["results"][c.id] = {
                    "country_id": c.id,
                    "country_name": c.country_name,
                    "olympics_hosted": olympics
                }
            end

            obj

        end

        def build_country(country)

            obj = {}

            olympics = {}

            country.olympics.each do |o|
                olympics[o.id] = {
                    "olympic_id": o.id,
                    "year": o.year,
                    "season": o.season,
                    "city": o.city.city_name
                } 
            end

            obj["results"] = {}

            obj["results"][country.id] = {
                "country_id": country.id,
                "country_name": country.country_name,
                "olympics_hosted": olympics
            }

        end

end
