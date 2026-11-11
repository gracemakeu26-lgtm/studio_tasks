require "test_helper"

class TaskTest < ActiveSupport::TestCase
  setup do
    @task = Task.new(title: "Commander le gel", priority: 1)
  end

  test "validates presence of title" do
   @task.title = nil
   assert_not @task.valid?
   assert_includes @task.errors[:title], "est obligatoire"
  end
  test "too long title" do
   @task.title = "a" * 256
   assert_not @task.valid?
   assert_includes @task.errors[:title], "ne doit pas dépasser 120 caractères"
  end
  test "valid title" do
   @task.title = "a" * 120
   assert @task.valid?
  end
  test "invalid priority" do
   @task.priority = 9
   assert_not @task.valid?
   assert_includes @task.errors[:priority], "n'est pas valide"
  end
  test "valid priority" do
   assert @task.valid?
  end
  test "too long description" do
   @task.description = "a" * 501
   assert_not @task.valid?
   assert_includes @task.errors[:description], "est trop long (pas plus de 500 caractères)"
  end
  test "valid description" do
   @task.description = "a" * 500
   assert @task.valid?
  end
  test "empty fields" do
   @task.due_on = nil
   @task.description = nil
   assert @task.valid?
  end
  test "valid fields" do
   @task.due_on = Date.today
   @task.description = "a" * 500
   assert @task.valid?
  end
  test "overdue scope" do
   task1 = tasks(:late_towels)
   task2 = tasks(:gel_order)

   overdue_tasks = Task.overdue

   assert_includes overdue_tasks, task1
   assert_not_includes overdue_tasks, task2
  end
  test "open_tasks scope" do
   task1 = tasks(:gel_order)
   task2 = tasks(:unscheduled_appointment)

   open_tasks = Task.open_tasks

   assert_includes open_tasks, task1
   assert_not_includes open_tasks, task2
  end
  test "unassigned scope" do
    unassigned_task = tasks(:unassigned_task)

    assert_includes Task.unassigned, unassigned_task
    assert_not_includes Task.unassigned, tasks(:gel_order)
  end

  test "belongs to its assigned user" do
    assert_equal users(:Camile), tasks(:gel_order).user
  end

  test "user has only its assigned tasks" do
    assert_equal [ tasks(:gel_order) ], users(:Camile).tasks.to_a
    assert_not_includes users(:Nora).tasks, tasks(:gel_order)
  end

  test "allows tasks without an assigned user" do
    unassigned_task = tasks(:unassigned_task)

    assert_nil unassigned_task.user
    assert_includes Task.unassigned, unassigned_task
  end

  test "nullifies task assignment when its user is destroyed" do
    task = tasks(:gel_order)

    users(:Camile).destroy!

    assert_nil task.reload.user_id
  end

  test "overdue scope excludes completed tasks and composes with user association" do
    overdue_tasks = Task.overdue

    assert_includes overdue_tasks, tasks(:late_towels)
    assert_not_includes overdue_tasks, tasks(:gel_order)
    assert_not_includes overdue_tasks, tasks(:unscheduled_appointment)
    assert_equal [ tasks(:late_towels) ], users(:Laurent).tasks.overdue.to_a
    assert_empty users(:Nora).tasks.overdue
  end

  test "due today scope includes tasks due today and excludes completed tasks" do
    due_today_tasks = Task.due_today

    assert_includes due_today_tasks, tasks(:unassigned_task)
    assert_not_includes due_today_tasks, tasks(:late_towels)
    assert_not_includes due_today_tasks, tasks(:unscheduled_appointment)
    assert_not_equal [ tasks(:unassigned_task) ], users(:Nora).tasks.due_today.to_a
    assert_empty users(:Laurent).tasks.due_today
  end
end
