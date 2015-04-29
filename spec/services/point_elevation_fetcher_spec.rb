require 'rails_helper'

describe PointElevationFetcher do
  let(:service) { PointElevationFetcher }
  let(:point1) { Point.new("latitude": 32.9377784729004, "longitude": -117.230392456055, 'distance': 0.045) }
  let(:point2) { Point.new("latitude": 32.937801361084, "longitude": -117.230323791504, 'distance': 0.145) }
  let(:point3) { Point.new("latitude": 32.9378204345703, "longitude": -117.230278015137, 'distance': 1.045) }

  before do
    stubs = Faraday::Adapter::Test::Stubs.new
    faraday = Faraday.new do |builder|
      builder.adapter :test, stubs do |stub|
        bulk_json = [point1, point2, point3].map{|pt| { latitude: pt.latitude, longitude: pt.longitude }}
        stub.get("/#{point2.latitude}/#{point2.longitude}") { |env| [200, {}, '220'] }
        stub.get("/#{point3.latitude}/#{point3.longitude}") { |env| [200, {}, '30'] }
        stub.post("/bulk") { |env| [200, bulk_json, '[11, 22, 33]'] }
      end
    end
    service.any_instance.stub(:connection).and_return(faraday)
  end

  it 'should fetch elevation value for single point' do
    expect(service.new(point2).fetch).to eq 220
    expect(service.new(point3).fetch).to eq 30
  end

  it 'should fetch elevation values for multiple points' do
    expect(service.new([point1, point2, point3]).fetch).to eq [11, 22, 33]
  end
end