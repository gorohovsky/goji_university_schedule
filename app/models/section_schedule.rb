class SectionSchedule < ApplicationRecord
  belongs_to :section

  MIN_START_TIME = '7:30am'.freeze
  MAX_END_TIME = '10:00pm'.freeze

  ALLOWED_DURATIONS = [50.minutes, 80.minutes].freeze
  DURATION_ERROR = 'Section duration must be 50 or 80 minutes'.freeze
  DEFAULT_TIME_FORMAT = '%I:%M%p'.freeze

  enum :day_of_week, Monday: 1, Tuesday: 2, Wednesday: 3, Thursday: 4, Friday: 5, Saturday: 6, Sunday: 7

  validates :start_time, timeliness: {
    on_or_after: MIN_START_TIME,
    message: "must be >= #{MIN_START_TIME}",
    type: :time
  }

  validates :end_time, timeliness: {
    after: :start_time,
    message: 'must be > start_time',
    type: :time
  }

  validates :end_time, timeliness: {
    on_or_before: MAX_END_TIME,
    message: "must be <= #{MAX_END_TIME}",
    type: :time
  }

  validate :ensure_correct_time_slot_duration

  def overlaps?(other_time_slot)
    return false if day_of_week != other_time_slot.day_of_week

    to_range.overlap? other_time_slot.to_range
  end

  def to_range = start_time...end_time

  def duration = end_time - start_time

  def interval = "#{formatted_start_time} - #{formatted_end_time}"

  %i[start_time end_time].each do |method_name|
    define_method("formatted_#{method_name}") do
      format_time send(method_name)
    end
  end

  private

  def ensure_correct_time_slot_duration
    return if ALLOWED_DURATIONS.include?(duration)

    errors.add(:invalid_duration, DURATION_ERROR)
  end

  def format_time(time, format = DEFAULT_TIME_FORMAT)
    time.strftime(format).downcase
  end
end
