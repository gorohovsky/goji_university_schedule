module ParamValidations
  module Enrollments
    class Create < Dry::Validation::Contract
      params do
        required(:enrollment).hash do
          required(:student_id).filled(:integer, gt?: 0)
          required(:section_id).filled(:integer, gt?: 0)
        end
      end
    end
  end
end
