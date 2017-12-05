class Olympic < ApplicationRecord
    has_many :medals
    has_many :events, through: :medals
end
