module Api
  class UsersController < ApplicationController
    skip_before_action :verify_authenticity_token
    before_action :authenticate_user!

    def show
      render json: current_user
    end
  end
end
