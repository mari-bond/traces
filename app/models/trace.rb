class Trace < ActiveRecord::Base
  def import_points(points_data)
    new_points = PointsBuilder.new(self, points_data).build
    all_points = points_as_json + new_points.as_json
    points_json = ActiveSupport::JSON.encode(all_points)

    update_attributes(points: points_json)
  end

  def points_as_json
    points.blank? ? [] : ActiveSupport::JSON.decode(points)
  end
end
