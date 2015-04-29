class AddPointsFieldToTraces < ActiveRecord::Migration
  def change
    add_column :traces, :points, :text
  end
end
