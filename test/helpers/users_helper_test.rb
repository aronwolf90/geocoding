require "test_helper"

class UsersHelperTest < ActionView::TestCase
  setup do
    @user = users(:one)
  end

  test "user_geolocated_attribute returns a failure message when status is failed" do
    @user.geolocation_process_status = "failed"

    assert_equal user_geolocated_attribute(@user, :state),
      "Failed to get state by geolocation"
  end

  test "user_geolocated_attribute returns attribute when status is succeeded" do
    @user.update!(state: "Baviera")
    @user.geolocation_process_status = "succeeded"

    assert_equal user_geolocated_attribute(@user, :state),
      @user.state
  end

  test "user_geolocated_attribute returns a is processing message when status is undefined" do
    @user.geolocation_process_status = "undefined"

    assert_equal user_geolocated_attribute(@user, :state),
      "Processing geolocation. Pleas try again later."
  end
end
