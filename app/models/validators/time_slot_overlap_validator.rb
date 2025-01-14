module Validators
  class TimeSlotOverlapValidator < ActiveModel::Validator
    ERROR_TEMPLATE = "'%s' and '%s' on %s".freeze

    def validate(section)
      group_schedules_by_day(section).each do |day_schedules|
        case day_schedules.size
        when 1
          next
        when 2
          check_overlap(section, *day_schedules)
        when (3..)
          day_schedules.combination(2).each { check_overlap(section, *_1) }
        end
      end
    end

    private

    def group_schedules_by_day(section)
      section.section_schedules.group_by(&:day_of_week).values
    end

    def check_overlap(section, time_slot1, time_slot2)
      return unless time_slot1.overlaps?(time_slot2)

      section.errors.add(:time_slot_conflict, error_message(time_slot1, time_slot2))
    end

    def error_message(time_slot1, time_slot2)
      format(ERROR_TEMPLATE, time_slot1.interval, time_slot2.interval, time_slot2.day_of_week)
    end
  end
end
