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
    if @task.save
      redirect_to tasks_path, notice: "Tâche créée avec succès :)"
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def task_params
    params.require(:task).permit(:title, :description, :done, :due_on, :priority)
  end
end