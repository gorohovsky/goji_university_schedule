class Section < ApplicationRecord
  belongs_to :teacher, default:   -> { Teacher.find teacher_id }
  belongs_to :subject, default:   -> { Subject.find subject_id }
  belongs_to :classroom, default: -> { Classroom.find classroom_id }
  has_many   :enrollments, dependent: :destroy
  has_many   :section_schedules, dependent: :destroy

  accepts_nested_attributes_for :section_schedules

  validate :ensure_teacher_teaches_subject
  validates :section_schedules, presence: true
  validates_with TimeSlotOverlapValidator
  validates_with TeacherClassroomAvailabilityValidator

  def overlaps?(another_section)
    section_schedules.any? do |ss1|
      another_section.section_schedules.any? do |ss2|
        ss1.overlaps? ss2
      end
    end
  end

  def days_of_week
    section_schedules.collect(&:day_of_week).uniq
  end

  private

  def ensure_teacher_teaches_subject
    return if teacher.subject? subject

    errors.add :teacher_subject_conflict, Teacher::SUBJECT_CONFLICT_ERROR
  end
end
