class Point < ActiveRecord::Base
  belongs_to :trace

  validates :latitude, :longitude, presence: true, numericality: true
  validates_presence_of :trace
end
