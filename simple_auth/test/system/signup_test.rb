require "test_helper"

class SignUpTest < ActionDispatch::SystemTestCase
  driven_by :rack_test

  def setup
    @user = users(:one)
  end

  test "signs a user up and signs out" do
    visit new_registration_path

    fill_in "account_name", with: "Test Account"
    fill_in "user_name", with: "Test User"
    fill_in "user_email_address", with: "test@example.com"
    fill_in "user_password", with: "password"
    fill_in "user_password_confirmation", with: "password"
    click_button "Sign up"

    assert_equal root_path, current_path

    click_link "Logout"
    assert_equal new_session_path, current_path
  end

  test "does not sign a user up with invalid credentials" do
    visit new_registration_path

    fill_in "account_name", with: ""
    fill_in "user_name", with: ""
    fill_in "user_email_address", with: ""
    fill_in "user_password", with: "1"
    fill_in "user_password_confirmation", with: "password"
    click_button "Sign up"

    assert_text "Email address can't be blank"
    assert_text "Name can't be blank"
    assert_text "Account is invalid"
    assert_text "Password is too short"
    assert_text "Password confirmation doesn't match Password"

    assert_equal registrations_path, current_path
  end
end
