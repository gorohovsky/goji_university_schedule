class EnrollmentsController < ApplicationController
  before_action :validate_params, :set_student, :set_section, only: :create
  before_action :set_enrollment, only: %i[show destroy]

  def show
    render json: @enrollment
  end

  def create
    @enrollment = @student.enrollments.new(section: @section)

    if @enrollment.save
      render json: @enrollment, status: 201, location: @enrollment
    else
      render json: @enrollment.errors, status: 422
    end
  end

  def destroy
    @enrollment.destroy!
  end

  private

  def set_enrollment
    @enrollment = Enrollment.find params[:id]
  end

  def set_student
    @student = Student.find enrollment_params[:student_id]
  end

  def set_section
    @section = Section.find enrollment_params[:section_id]
  end

  def enrollment_params = @valid_params[:enrollment]
end
