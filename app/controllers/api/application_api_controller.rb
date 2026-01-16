# app/controllers/api/application_api_controller.rb
module Api
  class ApplicationApiController < ApplicationController
    # common API behavior can be added here
    # example: force JSON, errors management, authentication, etc.

    before_action :set_default_format

    private

    def set_default_format
      request.format = :json
    end
  end
end
