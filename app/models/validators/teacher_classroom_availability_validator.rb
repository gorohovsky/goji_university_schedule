module Validators
  class TeacherClassroomAvailabilityValidator < ActiveModel::Validator
    ERROR_TEMPLATE = 'The %s is busy with section %s'.freeze

    def validate(section)
      potential_conflicts(section).each do |other_section|
        next unless section.overlaps? other_section

        add_conflict_error(section, other_section)
      end
    end

    private

    def potential_conflicts(section)
      Section
        .joins(:section_schedules)
        .includes(:section_schedules, :teacher, :classroom)
        .where(section_schedules: { day_of_week: section.days_of_week })
        .where.not(id: section.id)
        .and(
          Teacher.where(id: section.teacher_id)
            .or(Classroom.where(id: section.classroom_id))
        )
    end

    def add_conflict_error(section, conflicting_section)
      resource = conflict_resource(section, conflicting_section)
      message = error_message(resource, conflicting_section)

      section.errors.add("#{resource}_section_conflict", message)
    end

    def conflict_resource(section, conflicting_section)
      section.teacher == conflicting_section.teacher ? :teacher : :classroom
    end

    def error_message(conflict_resource, conflicting_section)
      format(ERROR_TEMPLATE, conflict_resource, conflicting_section.id)
    end
  end
end
