class AddDistanceToPoints < ActiveRecord::Migration
  def change
    add_column :points, :distance, :float, default: 0
  end
end
