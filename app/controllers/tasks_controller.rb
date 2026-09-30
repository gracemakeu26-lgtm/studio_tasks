class TasksController < ApplicationController
  def index
    @tasks = Task.order(done: :asc, due_on: :asc)
  end

  def show
    @task = Task.find(params[:id])
  end
end
