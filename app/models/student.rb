class Student < ApplicationRecord
  has_many :enrollments, dependent: :destroy
  has_many :sections, through: :enrollments

  validates :first_name, :last_name, presence: true

  def sections_with_schedules = sections.includes(:section_schedules)
end
