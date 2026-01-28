module Api
  class TestController < ApplicationApiController
    before_action :authenticate_user!

    def index
      render json: { "payload": "hello from authorized endpoint" }
    end
  end
end
