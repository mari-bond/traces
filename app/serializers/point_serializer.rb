class PointSerializer < ActiveModel::Serializer
  attributes :latitude, :longitude, :distance
end