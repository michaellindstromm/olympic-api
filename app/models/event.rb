class Event < ApplicationRecord
    belongs_to :discipline
    has_many :medals
    has_one :olympic, through: :medals
end
