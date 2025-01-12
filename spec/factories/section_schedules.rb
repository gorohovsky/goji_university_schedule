FactoryBot.define do
  factory :section_schedule do
    section { nil }
    day_of_week { :Monday }
    start_time { '8:00am' }
    end_time   { '8:50am' }
  end
end
