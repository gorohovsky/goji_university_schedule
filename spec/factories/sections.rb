FactoryBot.define do
  factory :section do
    teacher
    subject { teacher.subjects.first }
    classroom

    transient do
      default_time_slots do
        [
          [:Monday,    '7:30am', '8:20am'],
          [:Wednesday, '8:00am', '8:50am'],
          [:Friday,    '8:00am', '8:50am']
        ]
      end
      extra_time_slots { nil }

      time_slots do
        extra_time_slots ? (default_time_slots + extra_time_slots) : default_time_slots
      end
    end

    trait :with_overlapping_time_slots do
      extra_time_slots { [[:Monday, '8:00am', '8:50am']] }
    end

    after :build do |section, evaluator|
      evaluator.time_slots.each do |day_of_week, start_time, end_time|
        section.section_schedules << build(:section_schedule, day_of_week:, start_time:, end_time:)
      end
    end
  end
end
