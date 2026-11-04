require "test_helper"

class TasksControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    sign_in_as(User.take)
    get tasks_url
    assert_response :success
  end

  test "should get show" do
    sign_in_as(User.take)
    get tasks_url(@task)
    assert_response :success
  end
end
