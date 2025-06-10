require "test_helper"

class RegistrationsControllerTest < ActionDispatch::IntegrationTest
  test "can open registrations new page" do
    get new_registration_url
    assert_response :success
  end

  test "can register user" do
    assert_difference("User.count") do
      post registration_path, params: {
        user: {
          email_address: "test@example.com",
          password: "testtest",
          password_confirmation: "testtest"
        }
      }
    end

    assert_redirected_to new_session_path
  end

  test "shows validations errors when params are invalid" do
    assert_no_difference("User.count") do
      post registration_path, params: {
        user: {
          email_address: "test@example.com",
          password: "testtest",
          password_confirmation: "other"
        }
      }
    end

    assert_response :unprocessable_entity
    assert_includes @response.body, "invalid-feedback"
  end
end
