require 'rails_helper'

RSpec.describe Point, type: :model do
  let(:trace) { create(:trace) }
  let(:poin1_data) {{ "latitude": 32.9377784729004, "longitude": -117.230392456055 }}
  let(:poin2_data) {{ "latitude": 32.937801361084, "longitude": -117.230323791504 }}

  it { expect(subject).to belong_to(:trace) }
  it { expect(subject).to validate_presence_of(:longitude) }
  it { expect(subject).to validate_presence_of(:latitude) }
  it { expect(subject).to validate_numericality_of(:longitude) }
  it { expect(subject).to validate_numericality_of(:latitude) }

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

  it 'should build trace points' do
    new_point1 = build(:point, trace: trace)
    new_point1.attributes = poin1_data
    new_point2 = build(:point, trace: trace)
    new_point2.attributes = poin2_data
    new_points = Point.send(:build_points, trace, [poin1_data, poin2_data])

    expect(new_points[0].attributes).to eq new_point1.attributes
    expect(new_points[1].attributes).to eq new_point2.attributes
    expect(new_points.count).to eq 2
  end
end
