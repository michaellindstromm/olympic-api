class Sport < ApplicationRecord

    has_many :events
    has_many :disciplines

end
