require 'rails_helper'

RSpec.describe Trace, type: :model do
  it 'should create Trace' do
    expect { create(:trace) }.to change(Trace, :count)
  end

  it 'should import points' do
    trace = create(:trace)
    points_data = [build(:point), build(:point)]
    Point.stub(:import_trace_points)
    trace.import_points(points_data)

    expect(Point).to have_received(:import_trace_points).with(trace, points_data)
  end
end
