class Enrollment < ApplicationRecord
  belongs_to :student
  belongs_to :section

  OVERLAP_ERROR_TEMPLATE = 'Sections %s and %s overlap in their schedules'.freeze

  validate :ensure_no_overlapping_enrollments

  private

  def ensure_no_overlapping_enrollments
    student.sections_with_schedules.where.not(id: section_id).each do |existing_section|
      next unless section.overlaps? existing_section

      errors.add :enrollment_conflict, overlap_error(existing_section)
    end
  end

  def overlap_error(overlapping_section)
    format(OVERLAP_ERROR_TEMPLATE, section.id, overlapping_section.id)
  end
end
