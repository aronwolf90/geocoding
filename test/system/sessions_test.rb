require "application_system_test_case"

class SessionsTest < ApplicationSystemTestCase
  setup do
    @user = users(:one)
  end

  test "sign in and sign out" do
    visit new_session_path

    fill_in "Email address", with: @user.email_address
    fill_in "Password", with: "password"
    click_on "Sign in"

    assert_text "User #{@user.email_address}"

    click_on "Sign out"
    assert_text "Sign in"
  end
end
