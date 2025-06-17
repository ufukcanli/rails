require "test_helper"

class PasswordsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    @token = @user.password_reset_token
  end

  test "should get new" do
    get new_password_url
    assert_response :success
  end

  test "should create password and send reset instructions if email exists" do
    post passwords_url, params: { email_address: @user.email_address }
    assert_redirected_to new_session_url
    follow_redirect!
    assert_match /Password reset instructions sent/, response.body
  end

  test "should create password and send reset instructions if email does not exist" do
    post passwords_url, params: { email_address: "nonexistent@example.com" }
    assert_redirected_to new_session_url
    follow_redirect!
    assert_match /Password reset instructions sent/, response.body
  end

  test "should get edit with valid token" do
    get edit_password_url(token: @token)
    assert_response :success
  end

  test "should redirect to new password on invalid token" do
    get edit_password_url(token: "invalid token")
    assert_redirected_to new_password_url
  end

  test "should update password with valid parameters" do
    patch password_url(token: @token), params: { password: "newpassword", password_confirmation: "newpassword" }
    assert_redirected_to new_session_url
    follow_redirect!
    assert_match /Password has been reset/, response.body
  end

  test "should not update password with invalid parameters" do
    patch password_url(token: @token), params: { password: "newpassword", password_confirmation: "wrongconfirmation" }
    assert_redirected_to edit_password_url(token: @token)
  end
end
