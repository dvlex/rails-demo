# app/controllers/api/errors_controller.rb
module Api
  class ErrorsController < ApplicationApiController
    def route_not_found
      render json: { error: "Route not found" }, status: :not_found
    end
  end
end
