require "application_system_test_case"

class RegistrationsTest < ApplicationSystemTestCase
  setup do
    @user = users(:one)
  end

  test "can register user" do
    visit new_registration_path

    fill_in "Email", with: "test@example.com"
    fill_in "Password", with: "testtest"
    fill_in "Password confirmation", with: "testtest"
    fill_in "Street", with: "Prinzstraße 1"
    fill_in "Zip code", with: "86153"
    fill_in "City", with: "Augsburg"
    fill_in "Country", with: "Germany"
    click_on "Create account"

    assert_text "You have been successfully registered. You can now sign in."
  end
end
