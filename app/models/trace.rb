class Trace < ActiveRecord::Base
  has_many :points, inverse_of: :trace, dependent: :destroy

  def import_points(points_data)
    Point.import_trace_points(self, points_data)
  end
end
