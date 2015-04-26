class Point < ActiveRecord::Base
  reverse_geocoded_by :latitude, :longitude

  belongs_to :trace

  validates :latitude, :longitude, :distance, :elevation, presence: true, numericality: true
  validates_numericality_of :distance, :elevation, greater_than_or_equal_to: 0
  validates_presence_of :trace

  class << self
    def import_trace_points(trace, points_data)
      new_points = build_points(trace, points_data)
      import(new_points)
    end

    private

    def build_points(trace, data)
      data ||= []
      points = []
      if trace
        last = where(trace: trace).last
        data.each do |point_data|
          point = new point_data
          point.trace = trace
          if last
            point.distance = point.distance_to(last).round(5) + last.distance
          end
          last = point
          points << point
        end
      end
      elevations = PointElevationFetcher.new(points).fetch
      points.map.with_index{|point, index| point.elevation = elevations[index] } if elevations

      points
    end
  end
end
