class Teacher < ApplicationRecord
  has_many :sections, dependent: :destroy
  has_many :teacher_subjects, dependent: :destroy
  has_many :subjects, through: :teacher_subjects
end
