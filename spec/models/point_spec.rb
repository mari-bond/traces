require 'rails_helper'

RSpec.describe Point, type: :model do
  it { expect(subject).to belong_to(:trace) }
  it { expect(subject).to validate_presence_of(:longitude) }
  it { expect(subject).to validate_presence_of(:latitude) }
  it { expect(subject).to validate_numericality_of(:longitude) }
  it { expect(subject).to validate_numericality_of(:latitude) }

  it 'should create Point' do
    expect { create(:point) }.to change(Point, :count)
  end
end
