class Teacher < ApplicationRecord
  has_many :sections, dependent: :destroy
  has_many :teacher_subjects, dependent: :destroy
  has_many :subjects, through: :teacher_subjects

  validates :first_name, :last_name, presence: true

  SUBJECT_CONFLICT_ERROR = "The teacher doesn't teach the subject".freeze

  def subject?(subject) = subjects.include? subject
end
