require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "downcases and strips email_address" do
    user = User.new(email_address: " DOWNCASED@STUDIO-TASK.COM ")
    assert_equal("downcased@studio-task.com", user.email_address)
  end
end
