class CreatePoints < ActiveRecord::Migration
  def change
    create_table :points do |t|
      t.decimal :latitude, :precision => 15, :scale => 10
      t.decimal :longitude, :precision => 15, :scale => 10
      t.references :trace, index: true

      t.timestamps
    end
    add_foreign_key :points, :traces
  end
end
