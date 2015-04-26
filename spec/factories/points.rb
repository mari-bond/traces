FactoryGirl.define do
  factory :point do
    latitude { Faker::Address.latitude }
    longitude { Faker::Address.longitude }
    trace
  end
end
