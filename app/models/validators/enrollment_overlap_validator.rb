module Validators
  class EnrollmentOverlapValidator < OverlapValidator
    ERROR_TEMPLATE = 'Sections %s and %s overlap in their schedules'.freeze

    def validate(enrollment)
      check_for_overlaps(enrollment.section, potential_conflicts(enrollment)) do |conflicting_section|
        add_conflict_error(enrollment, conflicting_section)
      end
    end

    private

    def potential_conflicts(enrollment)
      enrollment.student.sections_with_schedules.where.not(id: enrollment.section_id)
    end

    def add_conflict_error(enrollment, conflicting_section)
      enrollment.errors.add :enrollment_conflict, error_message(enrollment, conflicting_section)
    end

    def error_message(enrollment, conflicting_section)
      format(ERROR_TEMPLATE, enrollment.section_id, conflicting_section.id)
    end
  end
end
