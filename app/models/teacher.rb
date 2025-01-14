class Teacher < ApplicationRecord
  has_many :sections, dependent: :destroy
  has_many :teacher_subjects, dependent: :destroy
  has_many :subjects, through: :teacher_subjects

  validates :first_name, :last_name, presence: true
end
