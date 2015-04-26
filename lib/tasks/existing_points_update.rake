require 'rake'

namespace :points do
  desc "Calculates and updates distance for existing points"
  task :update_distance => :environment do
    updated_count = 0
    p "Updating:"
    Trace.includes(:points).each do |trace|
      last_trace_point = nil
      trace.points.each do |point|
        if last_trace_point
          distance_to_prev = point.distance_to(last_trace_point).round(5)
          distance = last_trace_point.distance + distance_to_prev
          point.update_column(:distance, distance)
          updated_count += 1
        end
        last_trace_point = point
      end
      print "*"
    end
    p "Updated #{updated_count} points"
  end

  desc "Calculates and updates elevation for existing points"
  task :update_elevation => :environment do
    updated_count = 0
    points_groups = Point.all.to_a.in_groups_of(100)
    points_groups.each do |points_group|
      points_group.reject!(&:blank?)
      elevations = PointElevationFetcher.new(points_group).fetch
      if elevations
        points_group.each_with_index do |point, index|
          point.update_column(:elevation, elevations[index])
          updated_count += 1
        end
      end
      print "*"
    end
    p "Updated #{updated_count} points"
  end
end
