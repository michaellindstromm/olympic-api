class Country < ApplicationRecord
    has_many :cities
    has_many :olympics, through: :cities

    has_many :medals
    has_many :athletes, through: :medals
end
