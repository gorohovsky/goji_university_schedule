FactoryBot.define do
  factory :section_schedule do
    section { nil }
    day_of_week { :Monday }
    start_time { '8:00am' }
    end_time   { '8:50am' }

    transient do
      time_slot { [] }
    end

    after :build do |schedule, evaluator|
      schedule.day_of_week, schedule.start_time, schedule.end_time = evaluator.time_slot unless evaluator.time_slot.empty?
    end
  end
end
