class City < ApplicationRecord
    has_many :olympics
    belongs_to :country
end
