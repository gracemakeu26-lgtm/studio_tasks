class TasksController < ApplicationController
  def index
    @tasks = Task.order(done: :asc, due_on: :asc)
  end

  def show
    @task = Task.find(params[:id])
  end

  def new
    @task = Task.new
  end

  def create
    @task = Task.new(task_params)
    @task.save
    redirect_to tasks_path
  end

  private

  def task_params
    params.require(:task).permit(:title, :description, :done, :due_on, :priority)
  end
end