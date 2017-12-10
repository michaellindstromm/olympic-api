class Olympic < ApplicationRecord

    belongs_to :city
    has_one :country, through: :city

    has_many :medals
    has_many :events, through: :medals

    has_many :athletes, through: :medals
end
