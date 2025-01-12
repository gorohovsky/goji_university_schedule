FactoryBot.define do
  factory :classroom do
    name { "Room #{rand(1..1000)}" }
  end
end
