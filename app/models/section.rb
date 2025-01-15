class Section < ApplicationRecord
  belongs_to :teacher
  belongs_to :subject
  belongs_to :classroom
  has_many   :enrollments, dependent: :destroy
  has_many   :section_schedules, dependent: :destroy

  accepts_nested_attributes_for :section_schedules

  validate :ensure_teacher_teaches_subject
  validates :section_schedules, presence: true
  validates_with TimeSlotOverlapValidator
  validates_with TeacherClassroomAvailabilityValidator

  TEACHER_SUBJECT_CONFLICT_ERROR = "The teacher doesn't teach the subject".freeze

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
    return if teacher.subjects.include? subject

    errors.add :teacher_subject_conflict, TEACHER_SUBJECT_CONFLICT_ERROR
  end
end
