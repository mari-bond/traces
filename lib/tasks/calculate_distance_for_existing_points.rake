require 'rake'

namespace :points_distance do
  desc "Calculates and updates distance for existing points"

  task :update => :environment do
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
end
