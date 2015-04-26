class AddElevationToPoint < ActiveRecord::Migration
  def change
    add_column :points, :elevation, :float, default: 0
  end
end
