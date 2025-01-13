class ApplicationController < ActionController::API
  include ParamsGuard

  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  rescue_from ActiveRecord::RecordNotUnique, with: :record_not_unique

  private

  def record_not_found(error)
    render json: { error: error.message }, status: 404
  end

  def record_not_unique(error)
    render json: { error: 'Record already exists' }, status: 409
  end
end
