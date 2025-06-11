require "test_helper"

class RegistrationsControllerTest < ActionDispatch::IntegrationTest
  test "can open registrations new page" do
    get new_registration_path
    assert_response :success
  end

  test "can register user" do
    assert_difference("User.count") do
      post registration_path, params: {
        user: {
          email_address: "test@example.com",
          password: "testtest",
          password_confirmation: "testtest",
          street: "Prinzstraße 1",
          zip_code: "86153",
          city: "Augsburg",
          country: "Germany"
        }
      }
    end

    assert_redirected_to new_session_path
  end

  test "shows validation errors when params are invalid" do
    assert_no_difference("User.count") do
      post registration_path, params: {
        user: {
          email_address: "test@example.com",
          password: "testtest",
          password_confirmation: "other",
          street: "Prinzstraße 1",
          zip_code: "86153",
          city: "Augsburg",
          country: "Germany"
        }
      }
    end

    assert_response :unprocessable_entity
    assert_includes @response.body, "invalid-feedback"
  end
end
