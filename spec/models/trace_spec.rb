require 'rails_helper'

RSpec.describe Trace, type: :model do
  it 'should create Trace' do
    expect { create(:trace) }.to change(Trace, :count)
  end
end
