class Country < ApplicationRecord
    has_many :cities
    has_many :medals
    has_many :athletes, through: :medals
end
