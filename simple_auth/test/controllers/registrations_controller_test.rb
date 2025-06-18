require "test_helper"

class RegistrationsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get new_registration_url
    assert_response :success
  end

  test "should get create" do
    post registrations_url, params: {
      user: { email_address: "abc@123.com", name: "Test User", password: "password", password_confirmation: "password" },
      account: { name: "Acct" }
    }
    assert_response :redirect
    follow_redirect!
    assert_equal root_path, path
  end
end
