require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "create user" do
    assert User.create(
      email_address: "test@example.com",
      password: "testtest",
      password_confirmation: "testtest"
    )
  end
end
