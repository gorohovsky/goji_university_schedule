class Enrollment < ApplicationRecord
  belongs_to :student
  belongs_to :section

  validates_with EnrollmentOverlapValidator
end
