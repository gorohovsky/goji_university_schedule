FactoryBot.define do
  factory :subject do
    name { Faker::Science.unique.science }
  end
end
