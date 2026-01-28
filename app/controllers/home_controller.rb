class HomeController < ApplicationController
  before_action :authenticate_user!, only: [ :user ]

  def index
    @demos = Demo.all
  end

  def user
  end
end
