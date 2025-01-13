module ParamValidations
  module Sections
    class Create < Dry::Validation::Contract
      TIME_FORMAT = /\A(0?[1-9]|1[0-2]):([0-5][0-9])(am|pm)\z/i
      TIME_WARNING = 'must have correct format, e.g. 8:00am or 10:30pm'.freeze
      SECTION_SCHEDULES_KEY = %i[section section_schedules_attributes].freeze

      params do
        required(:section).hash do
          required(:teacher_id).filled(:integer, gt?: 0)
          required(:subject_id).filled(:integer, gt?: 0)
          required(:classroom_id).filled(:integer, gt?: 0)

          required(:section_schedules_attributes).value(:array, min_size?: 1).each do
            hash do
              required(:day_of_week).filled(:integer, gt?: 0, lt?: 8)
              required(:start_time).filled(:string)
              required(:end_time).filled(:string)
            end
          end
        end
      end

      rule('section.section_schedules_attributes') do
        section_schedules = values.dig(*SECTION_SCHEDULES_KEY)

        section_schedules.each_with_index do |time_slot, i|
          %i[start_time end_time].each do |param|
            next if valid_time? time_slot[param]

            param_path = key([*SECTION_SCHEDULES_KEY, i, param])
            param_path.failure TIME_WARNING
          end
        end
      end

      private

      def valid_time?(time_value)
        time_value.match? TIME_FORMAT
      end
    end
  end
end
