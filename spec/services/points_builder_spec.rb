require 'rails_helper'

describe PointsBuilder do
  subject { PointsBuilder }
  let(:trace) { create(:trace) }
  let(:trace_points_as_json) { [{ "latitude"=> 32.9378890991211, "longitude"=>-117.230072021484, "distance"=>0.00428, "elevation"=>4139.0 }] }
  let(:poin1_data) {{ "latitude": 32.9377784729004, "longitude": -117.230392456055 }}
  let(:poin2_data) {{ "latitude": 32.937801361084, "longitude": -117.230323791504 }}
  let(:poin3_data) {{ "latitude": 32.9378204345703, "longitude": -117.230278015137 }}

  describe 'should build trace points' do
    let(:new_point1) { Point.new(latitude: poin1_data[:latitude], longitude: poin1_data[:longitude], elevation: 11) }
    let(:new_point2) { Point.new(latitude: poin2_data[:latitude], longitude: poin2_data[:longitude], elevation: 22) }
    let(:new_point3) { Point.new(latitude: poin3_data[:latitude], longitude: poin3_data[:longitude], elevation: 33) }
    let(:distance_2_1) { 2.5 }
    let(:distance_3_2) { 0.15 }

    before do
      Geocoder::Calculations.stub(:distance_between)
        .with([new_point2.latitude, new_point2.longitude], [new_point1.latitude, new_point1.longitude]).and_return(distance_2_1)
      Geocoder::Calculations.stub(:distance_between)
        .with([new_point3.latitude, new_point3.longitude], [new_point2.latitude, new_point2.longitude]).and_return(distance_3_2)
      PointElevationFetcher.stub_chain(:new, :fetch).and_return([11, 22, 33])
    end

    it 'no points' do
      expect(subject.new(trace, nil).build).to eq []
    end

    it 'no trace' do
      expect(subject.new(nil, [poin1_data, poin2_data, poin3_data]).build).to eq []
    end

    it 'trace does not have points yet' do
      trace.stub(:points_as_json).and_return([])
      new_point2.distance = distance_2_1
      new_point3.distance = distance_3_2 + new_point2.distance
      new_points = subject.new(trace, [poin1_data, poin2_data, poin3_data]).build

      new_points.as_json.should match_array [new_point1, new_point2, new_point3].as_json
    end

    it 'trace already has points' do
      trace.stub(:points_as_json).and_return(trace_points_as_json)
      distance_1 = 3
      last = trace_points_as_json.last
      Geocoder::Calculations.stub(:distance_between)
        .with([new_point1.latitude, new_point1.longitude], [last['latitude'], last['longitude']]).and_return(distance_1)
      new_point1.distance = distance_1 + last['distance']
      new_point2.distance = distance_2_1 + new_point1.distance
      new_point3.distance = distance_3_2 + new_point2.distance
      new_points = subject.new(trace, [poin1_data, poin2_data, poin3_data]).build

      new_points.as_json.should match_array [new_point1, new_point2, new_point3].as_json
    end
  end
end