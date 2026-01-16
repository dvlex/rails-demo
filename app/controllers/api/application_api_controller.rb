# app/controllers/api/application_api_controller.rb
module Api
  class ApplicationApiController < ApplicationController
    # common API behavior can be added here
    # example: force JSON, errors management, authentication, etc.
    protect_from_forgery with: :null_session
    before_action :set_default_format

    rescue_from ActiveRecord::RecordNotFound, with: :render_not_found
    rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable
    rescue_from StandardError, with: :render_internal_error

    private

    def set_default_format
      request.format = :json
    end

    def render_not_found(exception)
      render json: { error: "Record not found", details: exception.message }, status: :not_found
    end

    def render_unprocessable(exception)
      render json: { error: "Unprocessable entity", details: exception.record.errors }, status: :unprocessable_entity
    end

    def render_internal_error(exception)
      render json: { error: "Internal server error", details: exception.message }, status: :internal_server_error
    end
  end
end
