FactoryGirl.define do
  factory :point do
    latitude { Faker::Address.latitude }
    longitude { Faker::Address.longitude }
    trace
    distance { Faker::Number.number(4).to_i/100000.to_f }
  end
end
