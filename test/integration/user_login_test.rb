require "test_helper"

class UserLoginTest < ActionDispatch::IntegrationTest
  test "The aesthetician lands on their own tasks after logging in" do
    user = users(:Laurent)
    user_task = tasks(:late_towels)
    other_tasks = tasks(:gel_order, :unscheduled_appointment, :unassigned_task)

    post session_path, params: { email_address: user.email_address, password: "secret123" }

    assert_redirected_to tasks_path(mine: 1)
    follow_redirect!
    assert_response :success

    assert_match user_task.title, response.body

    other_tasks.each do |task|
      assert_no_match task.title, response.body
    end
  end
end
