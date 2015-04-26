require 'rails_helper'

RSpec.describe Point, type: :model do
  let(:trace) { create(:trace) }
  let(:poin1_data) {{ "latitude": 32.9377784729004, "longitude": -117.230392456055 }}
  let(:poin2_data) {{ "latitude": 32.937801361084, "longitude": -117.230323791504 }}
  let(:poin3_data) {{ "latitude": 32.9378204345703, "longitude": -117.230278015137 }}

  it { expect(subject).to belong_to(:trace) }
  it { expect(subject).to validate_presence_of(:longitude) }
  it { expect(subject).to validate_presence_of(:latitude) }
  it { expect(subject).to validate_numericality_of(:longitude) }
  it { expect(subject).to validate_numericality_of(:latitude) }
  it { expect(subject).to validate_presence_of(:distance) }
  it { expect(subject).to validate_numericality_of(:distance).is_greater_than_or_equal_to(0) }
  it { expect(subject).to validate_presence_of(:elevation) }
  it { expect(subject).to validate_numericality_of(:elevation).is_greater_than_or_equal_to(0) }

  it 'should create Point' do
    expect { create(:point) }.to change(Point, :count)
  end

  it 'should import trace points' do
    new_points = [build(:point), build(:point)]
    Point.stub(:build_points).with(trace, [poin1_data, poin2_data]).and_return(new_points)
    Point.stub(:import)
    Point.import_trace_points(trace, [poin1_data, poin2_data])

    expect(Point).to have_received(:import).with(new_points)
  end

  describe 'should build trace points' do
    let(:new_point1) { build(:point, trace: trace, latitude: poin1_data[:latitude], longitude: poin1_data[:longitude], elevation: 11) }
    let(:new_point2) { build(:point, trace: trace, latitude: poin2_data[:latitude], longitude: poin2_data[:longitude], elevation: 22) }
    let(:new_point3) { build(:point, trace: trace, latitude: poin3_data[:latitude], longitude: poin3_data[:longitude], elevation: 33) }
    let(:distance_2_1) { new_point2.distance_to(new_point1).round(5) }
    let(:distance_3_2) { new_point3.distance_to(new_point2).round(5) }

    before do
      PointElevationFetcher.stub_chain(:new, :fetch).and_return([11, 22, 33])
    end

    it 'no points' do
      expect(Point.send(:build_points, trace, nil)).to eq []
    end

    it 'no trace' do
      expect(Point.send(:build_points, nil, [poin1_data, poin2_data])).to eq []
    end

    it 'trace does not have points yet' do
      new_point2.distance = distance_2_1
      new_point3.distance = distance_3_2 + new_point2.distance
      new_points = Point.send(:build_points, trace, [poin1_data, poin2_data, poin3_data])

      new_points.map(&:attributes).should match_array [new_point1, new_point2, new_point3].map(&:attributes)
    end

    it 'trace already has points' do
      point1 = create(:point, trace: trace)
      point2 = create(:point, trace: trace, distance: 20.3577574564)
      distance_1 = new_point1.distance_to(point2).round(5)
      new_point1.attributes = poin1_data.merge(distance: distance_1 + point2.distance)
      new_point2.attributes = poin2_data.merge(distance: distance_2_1 + new_point1.distance)
      new_point3.attributes = poin3_data.merge(distance: distance_3_2 + new_point2.distance)
      new_points = Point.send(:build_points, trace, [poin1_data, poin2_data, poin3_data])

      new_points.map(&:attributes).should match_array [new_point1, new_point2, new_point3].map(&:attributes)
    end
  end
end
