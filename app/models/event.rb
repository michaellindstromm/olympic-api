class Event < ApplicationRecord
    belongs_to :discipline
    has_many :medals
    has_many :olympics, through: :medals
end
