class TasksController < ApplicationController

  before_action :set_task, only: [:show, :edit, :update, :destroy]
  before_action :require_manager, only: [:destroy]
  before_action :require_edit_permission, only: [:edit, :update]

 def index
  @tasks = Task.includes(:user)

  case params[:filter]
  when "open_tasks"
    @tasks = @tasks.where(done: false)
  when "overdue"
    @tasks = @tasks.where(done: false).where("due_on < ?", Date.current)
  when "unassigned"
    @tasks = @tasks.where(user_id: nil)
  end

  if params[:mine] == "1"
      @tasks = Current.user ? @tasks.where(user: Current.user) : @tasks.none
    end

    @tasks = @tasks.order(done: :asc, due_on: :asc, priority: :desc)
end

  def show
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

  def edit
  end

  def update
    if @task.update(task_params)
      redirect_to tasks_path, notice: "Tâche modifiée."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @task.destroy
    redirect_to tasks_path, notice: "Tâche supprimée.", status: :see_other
  end

  private

  def set_task
    @task = Task.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to tasks_path,  alert: "Cette tâche n'existe pas ou a été supprimée."
  end

  def task_params
    if Current.user.manager?
      params.require(:task).permit(:title, :description, :done, :due_on, :priority, :user_id)
    else
      params.require(:task).permit(:title, :description, :done, :due_on, :priority)
    end
  end

  def require_manager
    redirect_to tasks_path, alert: "Action réservée à la gérante." unless Current.user.manager? #matrix : delete task : mnager only  
  end
  def require_edit_permission
    allowed = Current.user.manager? || @task.user == Current.user
    redirect_to tasks_path, alert: "Tu ne peux modifier que tes tâches." unless allowed #matrix : modify / maek Done : manager all, esthetician his 
  end
end