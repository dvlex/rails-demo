module Api
  class TestController < ApplicationController
    skip_before_action :verify_authenticity_token
    before_action :authenticate_user!

    def index
      render json: { "payload": "hello from authorized endpoint" }
    end
  end
end
