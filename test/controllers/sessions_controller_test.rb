require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
  end

  test "redirects to new session path from root when the user is not signed in" do
    get root_path

    assert_redirected_to new_session_path
  end

  test "can open sessions/new page" do
    get new_session_path
    assert_response :success
  end

  test "can sign in" do
    assert_difference("Session.count") do
      post session_path, params: {
        user: {
          email_address: @user.email_address,
          password: "password"
        }
      }
    end

    assert_redirected_to root_path
  end

  test "shows error message when params are invalid" do
    assert_no_difference("Session.count") do
      post session_path, params: {
        user: {
          email_address: "test@example.com",
          password: "invalid"
        }
      }
    end

    assert_redirected_to new_session_path
    assert_equal flash[:alert], "Try another email address or password."
  end

  test "show correct session buttons" do
    get new_session_path

    assert_includes @response.body, "Log in"
    assert_includes @response.body, "Sign up"
    assert_not_includes @response.body, "Sign out"
  end
end
