module Api
  class TasksController < ApplicationApiController
    before_action :authenticate_user!

    def index
      tasks = current_user.tasks
      render json: TaskBlueprint.render(tasks)
    end
  end
end
