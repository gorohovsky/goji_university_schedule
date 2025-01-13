FactoryBot.define do
  factory :teacher do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }

    transient do
      subjects_count { 1 }
    end

    after :build do |teacher, evaluator|
      create_list(:subject, evaluator.subjects_count, teachers: [teacher])
    end
  end
end
