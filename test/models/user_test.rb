require "test_helper"

class UserTest < ActiveSupport::TestCase
  include ActiveJob::TestHelper

  setup do
    @user = users(:one)
  end

  test "create user triggers GeocodeJob" do
    user = User.new(
      email_address: "test@example.com",
      password: "testtest",
      password_confirmation: "testtest",
      street: "Prinzstraße 1",
      zip_code: "86153",
      city: "Augsburg",
      country: "Germany"
    )

    assert_enqueued_jobs 1, only: GeocodeJob do
      user.save!
    end
  end

  test "do not trigger GeocodeJob when the address does not change" do
    assert_no_enqueued_jobs only: GeocodeJob do
      @user.save!
    end
  end

  test "validates that the email is uniq" do
    user = User.new(@user.attributes.except(:id))

    assert user.invalid?

    user.email_address = "other@test.com"
    assert user.valid?
  end

  test "invalid without email_address" do
    @user.email_address = nil

    assert @user.invalid?
  end

  test "invalid without street" do
    @user.street = nil

    assert @user.invalid?
  end

  test "invalid without zip_code" do
    @user.zip_code = nil

    assert @user.invalid?
  end

  test "invalid without city" do
    @user.city = nil

    assert @user.invalid?
  end

  test "invalid without country" do
    @user.country = nil

    assert @user.invalid?
  end

  test "geocode! updates location attributes" do
    Geocoder::Lookup::Test.add_stub(
      @user.address, [
        {
          "coordinates"  => [ 40.7143528, -74.0059731 ],
          "state"        => "Baviera"
        }
      ]
    )

    @user.geocode!

    assert_equal @user.latitude, "40.7143528"
    assert_equal @user.longitude, "-74.0059731"
    assert_equal @user.state, "Baviera"
    assert_equal @user.geolocation_process_status, "succeeded"
  end

  test "geocode! sets failed when it can not golocate the address" do
    Geocoder::Lookup::Test.add_stub(
      @user.address, []
    )

    @user.geocode!

    assert_nil @user.latitude
    assert_nil @user.longitude
    assert_equal @user.geolocation_process_status, "failed"
  end
end
