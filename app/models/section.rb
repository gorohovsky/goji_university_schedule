class Section < ApplicationRecord
  belongs_to :teacher
  belongs_to :subject
  belongs_to :classroom
  has_many   :section_schedules, dependent: :destroy

  accepts_nested_attributes_for :section_schedules

  validates :section_schedules, presence: true

  validates_with TimeSlotOverlapValidator
end
