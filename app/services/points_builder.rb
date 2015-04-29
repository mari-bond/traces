class PointsBuilder
  attr_writer :trace, :points_data

  def initialize(trace, points_data)
    @trace = trace
    @points_data = points_data || []
  end

  def build
    points = []
    if @trace
      last_as_json = @trace.points_as_json.last
      last = Point.new last_as_json if last_as_json
      @points_data.each do |point_data|
        point = Point.new point_data
        if last
          point.distance = distance_between(point, last) + last.distance
        end
        last = point
        points << point
      end
    end
    points = set_elevation(points)

    points
  end

  private
  def distance_between(from_point, to_point)
    from_coords = [from_point.latitude, from_point.longitude]
    to_coords = [to_point.latitude, to_point.longitude]
    distance = Geocoder::Calculations.distance_between(from_coords, to_coords)

    distance.round(5)
  end

  def set_elevation(points)
    elevations = []
    points.in_groups_of(100).each do |group|
      group.reject!(&:blank?)
      elevations += PointElevationFetcher.new(group).fetch
    end
    if elevations.any?
      points.map.with_index{|point, i| point.elevation = elevations[i] }
    end

    points
  end
end
