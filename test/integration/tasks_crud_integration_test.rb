require "test_helper"

class TasksCrudIntegrationTest < ActionDispatch::IntegrationTest
  setup do
    @manager = users(:Camile) 
    @task = tasks(:gel_order)      
    
    sign_in_as users(:Camile)
  end

  test "Complete CRUD flow: valid creation, invalid creation, editing, and the dual-tab scenario" do

    assert_difference "Task.count", 1 do
      post tasks_path, params: { task: { title: "Nouvelle tâche de la gérante", due_on: Date.today + 7.days } }
    end
    
    assert_redirected_to tasks_path
    follow_redirect!
    assert_response :success
    assert_match "Nouvelle tâche de la gérante", response.body
    assert_not_nil flash[:notice]

    assert_no_difference "Task.count" do
      post tasks_path, params: { task: { title: "", due_on: Date.today + 7.days } } 
    end
    assert_response :unprocessable_entity

    patch task_path(@task), params: { task: { title: "Titre modifié par la gérante" } }
    assert_redirected_to tasks_path
    follow_redirect!
    assert_response :success
    
    @task.reload
    assert_equal "Titre modifié par la gérante", @task.title

    assert_difference "Task.count", -1 do
      delete task_path(@task)
    end
    assert_redirected_to tasks_path

    assert_no_difference "Task.count" do
      delete task_path(@task)
    end
    
    assert_redirected_to tasks_path
    follow_redirect!
    assert_response :success
    assert_not_nil flash[:alert]
  end
end