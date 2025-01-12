class Subject < ApplicationRecord
  has_many :sections, dependent: :destroy
  has_many :teacher_subjects, dependent: :destroy
  has_many :teachers, through: :teacher_subjects
end
