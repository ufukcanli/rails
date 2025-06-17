require "test_helper"

class SignInTest < ActionDispatch::SystemTestCase
  driven_by :rack_test

  def setup
    @user = users(:one)
  end

  test "signs a user in and signs out" do
    visit new_session_path
    fill_in "email_address", with: @user.email_address
    fill_in "password", with: "password"
    click_button "Sign in"

    assert_equal root_path, current_path

    click_link "Logout"
    assert_equal new_session_path, current_path
  end

  test "does not sign a user in with invalid credentials" do
    visit new_session_path
    fill_in "email_address", with: @user.email_address
    fill_in "password", with: "wrong password"
    click_button "Sign in"

    assert_equal new_session_path, current_path
  end
end
