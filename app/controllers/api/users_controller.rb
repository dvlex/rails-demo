module Api
  class UsersController < ApplicationApiController
    before_action :authenticate_user!

    def show
      render json: UserBlueprint.render(current_user)
    end
  end
end
