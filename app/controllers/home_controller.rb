class HomeController < ApplicationController
  def index
    @demos = Demo.all
  end
end
