require 'rake'

namespace :points do
  desc "Saves points as json and put to Trace"
  task :save_as_json => :environment do
    updated_count = 0
    p "Updating:"
    Trace.all.each do |trace|
      points_as_json = Trace.find_by_sql(["SELECT * FROM points WHERE trace_id = ?", trace.id])
      .as_json(only: [:longitude, :latitude, :distance, :elevation])
      trace.update_column(:points, points_as_json.to_json)
      updated_count += 1
      print "*"
    end
    p "Updated #{updated_count} traces"
  end
end