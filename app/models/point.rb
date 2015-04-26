class Point < ActiveRecord::Base
  reverse_geocoded_by :latitude, :longitude

  belongs_to :trace

  validates :latitude, :longitude, :distance, :elevation, presence: true, numericality: true
  validates_numericality_of :distance, :elevation, greater_than_or_equal_to: 0
  validates_presence_of :trace

  scope :in_trace, -> (trace_id) { where(trace_id: trace_id) }

  class << self
    def import_trace_points(trace, points_data)
      new_points = build_points(trace, points_data)
      columns = [:trace_id, :latitude, :longitude, :distance, :elevation]
      values = new_points.map{|pt| [pt.trace_id, pt.latitude, pt.longitude, pt.distance, pt.elevation] }

      import columns, values, validate: false
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
      elevations = find_points_elevations(points)
      points.map.with_index{|point, index| point.elevation = elevations[index] } if elevations

      points
    end

    def find_points_elevations(points)
      elevations = []
      points.in_groups_of(100).each do |group|
        group.reject!(&:blank?)
        elevations += PointElevationFetcher.new(group).fetch
      end

      elevations
    end
  end
end
