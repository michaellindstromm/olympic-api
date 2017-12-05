class Api::V2::SportSerializer < ActiveModel::Serializer
  attributes :id, :sport_name
 
  has_many :disciplines
end
