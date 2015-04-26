class TraceSerializer < ActiveModel::Serializer
  attributes :id

  has_many :points
end