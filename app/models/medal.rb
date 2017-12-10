class Medal < ApplicationRecord
    belongs_to :event
    belongs_to :olympic
    belongs_to :athlete
    belongs_to :country
end
