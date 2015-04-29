require 'rails_helper'

RSpec.describe Trace, type: :model do
  it 'should create Trace' do
    expect { create(:trace) }.to change(Trace, :count)
  end

  it 'should import points' do
    trace = create(:trace)
    points_as_json = [{ "latitude": 32.937931060791, "longitude": -117.229949951172 }]
    trace.stub(:points_as_json).and_return(points_as_json)
    new_point1 = Point.new("latitude": 32.9378890991211, "longitude": -117.230072021484)
    new_point2 = Point.new("latitude": 32.9378814697266, "longitude": -117.230102539062)
    points_data = [{ "latitude": 32.9377784729004, "longitude": -117.230392456055 }]
    all_points = points_as_json + [new_point1, new_point2].as_json
    PointsBuilder.stub_chain(:new, :build).with(trace, points_data).with(no_args).and_return([new_point1, new_point2])
    trace.import_points(points_data)

    trace.reload
    expect(trace.points).to eq(all_points.to_json)
  end
end