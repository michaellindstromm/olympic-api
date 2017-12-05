class Athlete < ApplicationRecord
    has_many :medals
    has_many :events, through: :medals
    has_one :country, through: :medals
end
