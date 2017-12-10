class Api::V2::CountriesController < ApplicationController

    def index
        countries = Country.all.page(params[:page]).per(params[:per_page])

        render json: build_countries(countries)
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

            obj[:meta] = add_meta(countries, 'countries')

            obj[:results] = []

            countries.each do |c|

                olympics = []

                c.olympics.each do |o|
                    olympic_data = {
                        olympic_id: o.id,
                        year: o.year,
                        season: o.season,
                        city: o.city.city_name
                    }

                    olympics << olympic_data
                end

                country_data = {
                    country_id: c.id,
                    country_name: c.country_name,
                    IOC_code: c.noc,
                    olympics_hosted: olympics
                }
                
                obj[:results] << country_data
            end

            obj

        end

        def build_country(c)

            obj = {}

            olympics = []

            c.olympics.each do |o|
                olympic_data = {
                    olympic_id: o.id,
                    year: o.year,
                    season: o.season,
                    city: o.city.city_name
                } 

                olympics << olympic_data
            end

            obj[:results] = {}

            obj[:results][c.id] = {
                country_id: c.id,
                country_name: c.country_name,
                IOC_code: c.noc,
                olympics_hosted: olympics
            }

        end

end
