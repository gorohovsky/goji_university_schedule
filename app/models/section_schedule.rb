class SectionSchedule < ApplicationRecord
  belongs_to :section

  MIN_START_TIME = '7:30am'.freeze
  MAX_END_TIME = '10:00pm'.freeze

  TIME_SLOT_DURATIONS = [50.minutes, 80.minutes].freeze
  DURATION_WARNING = 'Section duration must be 50 or 80 minutes'.freeze

  DEFAULT_TIME_FORMAT = '%I:%M%p'.freeze

  enum :day_of_week, Monday: 1, Tuesday: 2, Wednesday: 3, Thursday: 4, Friday: 5, Saturday: 6, Sunday: 7

  validates :start_time, timeliness: {
    on_or_after: MIN_START_TIME,
    on_or_after_message: "the earliest time is #{MIN_START_TIME}",
    type: :time
  }

  validates :end_time, timeliness: {
    after: :start_time,
    message: 'must be greater than start_time',
    type: :time
  }

  validates :end_time, timeliness: {
    on_or_before: MAX_END_TIME,
    message: "the latest time is #{MAX_END_TIME}",
    type: :time
  }

  validate :ensure_correct_time_slot_duration

  def overlaps?(other_time_slot)
    return false if day_of_week != other_time_slot.day_of_week

    (start_time...end_time).overlap?(other_time_slot.start_time...other_time_slot.end_time)
  end

  %i[start_time end_time].each do |method|
    define_method("formatted_#{method}") do
      format_time send(method)
    end
  end

  def interval
    "#{formatted_start_time} - #{formatted_end_time}"
  end

  private

  def ensure_correct_time_slot_duration
    return if TIME_SLOT_DURATIONS.include?(end_time - start_time)

    errors.add(:duration, DURATION_WARNING)
  end

  def format_time(time, format = DEFAULT_TIME_FORMAT)
    time.strftime(format).downcase
  end
end
