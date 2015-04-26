class Point < ActiveRecord::Base
  belongs_to :trace

  validates :latitude, :longitude, presence: true, numericality: true
  validates_presence_of :trace

  class << self
    def import_trace_points(trace, points_data)
      new_points = build_points(trace, points_data)
      import(new_points)
    end

    private

    def build_points(trace, data)
      data ||= []
      data.map { |point_data|
        point = new point_data
        point.trace = trace
        point
      }
    end
  end
end
