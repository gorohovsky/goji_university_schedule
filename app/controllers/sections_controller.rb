class SectionsController < ApplicationController
  before_action :validate_params, only: :create
  before_action :set_section, only: :show

  def show
    render json: @section
  end

  def create
    @section = Section.new(section_params)

    if @section.save
      render json: @section, status: 201, location: @section
    else
      render json: @section.errors, status: 422
    end
  end

  private

  def set_section
    @section = Section.find(params[:id])
  end

  def section_params
    @valid_params[:section]
  end
end
