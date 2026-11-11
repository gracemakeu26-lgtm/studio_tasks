require "test_helper"

class TasksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @gel_order_task = tasks(:gel_order)
    @manager = users(:Camile)
    @esthetician = users(:Laurent)
    @receptionist = users(:Nora)
    @unassigned_task = tasks(:unassigned_task)
    @late_towels_task = tasks(:late_towels)
    @overdue_task = @late_towels_task
  end
  test "unauthenticated visitors are redirected to the login page (GET /tasks)" do
    get tasks_path
    assert_redirected_to new_session_path
  end

  test "unauthenticated visitors are redirected when attempting to create a task (POST /tasks)" do
    assert_no_difference "Task.count" do
      post tasks_path, params: { task: { title: "Forged new task" } }
    end

    assert_redirected_to new_session_path
  end

  test "authenticated users can access the task list" do
    sign_in_as(@manager)

    get tasks_path
    assert_response :success
  end

  test "task list shows category counts and filters tasks due today" do
    sign_in_as(@manager)

    get tasks_path

    assert_response :success
    assert_select "a.task-filter[href='#{tasks_path}'] .task-filter-count", text: "4"
    assert_select "a.task-filter[href='#{tasks_path(filter: 'overdue')}'] .task-filter-count", text: "1"
    assert_select "a.task-filter[href='#{tasks_path(filter: 'open_tasks')}'] .task-filter-count", text: "3"
    assert_select "a.task-filter[href='#{tasks_path(filter: 'unassigned')}'] .task-filter-count", text: "1"
    assert_select "a.task-filter[href='#{tasks_path(mine: 1)}'] .task-filter-count", text: "1"
    assert_select "a.task-filter[href='#{tasks_path(filter: 'due_today')}'] .task-filter-count", text: "1"

    get tasks_path(filter: "due_today")

    assert_response :success
    assert_select "h2 a", text: "Tâche non assignée"
    assert_select "h2 a", text: "Commander le gel", count: 0
  end

  test "esthetician cannot delete a task" do
    sign_in_as(@esthetician)
    assert_no_difference "Task.count" do
      delete task_url(@gel_order_task)
    end
    assert_redirected_to tasks_path
  end

  test "manager can delete a task" do
    sign_in_as(@manager)
    assert_difference "Task.count", -1 do
      delete task_url(@gel_order_task)
    end
    assert_redirected_to tasks_path
  end

  test "receptionist cannot delete a task" do
    sign_in_as(@receptionist)
    assert_no_difference "Task.count" do
      delete task_url(@gel_order_task)
    end
    assert_redirected_to tasks_path
  end

  test "esthetician can modify his own task" do
    sign_in_as(@esthetician)
    patch task_url(@late_towels_task), params: { task: { title: "Modified title" } }
    assert_redirected_to tasks_path
    assert_equal "Modified title", @late_towels_task.reload.title
  end

  test "esthetician cannot modify another user's task" do
    sign_in_as(@esthetician)
    patch task_url(@unassigned_task), params: { task: { title: "Modified title" } }
    assert_redirected_to tasks_path
    assert_not_equal "Modified title", @unassigned_task.reload.title
  end

  test "manager can modify any task" do
    sign_in_as(@manager)
    patch task_url(@unassigned_task), params: { task: { title: "Modified title" } }
    assert_redirected_to tasks_path
    assert_equal "Modified title", @unassigned_task.reload.title
  end

  test "receptionist cannot modify any task" do
    sign_in_as(@receptionist)
    patch task_url(@unassigned_task), params: { task: { title: "Modified title" } }
    assert_redirected_to tasks_path
    assert_not_equal "Modified title", @unassigned_task.reload.title
  end

  test "manager can create a new task" do
    sign_in_as(@manager)
    assert_difference "Task.count", 1 do
      post tasks_url, params: { task: { title: "New Task", description: "This is a new task.", due_on: Date.today + 7.days, priority: 1, done: false } }
    end
    assert_redirected_to tasks_path
  end

  test "esthetician can create a new task" do
    sign_in_as(@esthetician)
    assert_difference "Task.count", 1 do
      post tasks_url, params: { task: { title: "New Task", description: "This is a new task.", due_on: Date.today + 7.days, priority: 1, done: false } }
    end
    assert_redirected_to tasks_path
  end

  test "receptionist can create a new task" do
    sign_in_as(@receptionist)
    assert_difference "Task.count", 1 do
      post tasks_url, params: { task: { title: "New Task", description: "This is a new task.", due_on: Date.today + 7.days, priority: 1, done: false } }
    end
    assert_redirected_to tasks_path
  end

  test "should get index" do
    sign_in_as(@manager)
    get tasks_url
    assert_response :success
  end

  test "should get show" do
    sign_in_as(@manager)
    get task_url(@gel_order_task)
    assert_response :success
  end
end
