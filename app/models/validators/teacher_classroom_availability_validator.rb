module Validators
  class TeacherClassroomAvailabilityValidator < OverlapValidator
    ERROR_TEMPLATE = 'The %s is busy with section %s'.freeze

    def validate(section)
      check_for_overlaps(section, potential_conflicts(section)) do |conflicting_section|
        add_conflict_error(section, conflicting_section)
      end
    end

    private

    def potential_conflicts(section)
      Section
        .joins(:section_schedules)
        .includes(:section_schedules)
        .where(section_schedules: { day_of_week: section.days_of_week })
        .where('teacher_id = ? OR classroom_id = ?', section.teacher_id, section.classroom_id)
        .where.not(id: section.id)
    end

    def add_conflict_error(section, conflicting_section)
      resource = conflict_resource(section, conflicting_section)
      message = error_message(resource, conflicting_section)

      section.errors.add("#{resource}_section_conflict", message)
    end

    def conflict_resource(section, conflicting_section)
      section.teacher_id == conflicting_section.teacher_id ? :teacher : :classroom
    end

    def error_message(conflict_resource, conflicting_section)
      format(ERROR_TEMPLATE, conflict_resource, conflicting_section.id)
    end
  end
end
