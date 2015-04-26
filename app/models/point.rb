class Point < ActiveRecord::Base
  reverse_geocoded_by :latitude, :longitude

  belongs_to :trace

  validates :latitude, :longitude, :distance, presence: true, numericality: true
  validates_numericality_of :distance, greater_than_or_equal_to: 0
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
        last_trace_point = where(trace: trace).last
        data.each do |point_data|
          point = new point_data
          point.trace = trace
          if last_trace_point
            distance_to_prev = point.distance_to(last_trace_point).round(5)
            point.distance = distance_to_prev + last_trace_point.distance
          end
          last_trace_point = point
          points << point
        end
      end

      points
    end
  end
end
