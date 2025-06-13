require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  test "redirects to feed after successful sign up" do
    get sign_up_path
    assert_response :ok

    assert_difference [ "User.count", "Organization.count" ], 1 do
      post sign_up_path, params: {
        user: {
          name: "John",
          email: "johndoe@example.com",
          password: "password"
        }
      }
    end

    assert_redirected_to root_path
    assert_not_empty cookies[:app_session]
    follow_redirect!
    assert_select ".notification.is-success", text: I18n.t("users.create.welcome", name: "John")
  end

  test "renders errors if input data is invalid" do
    get sign_up_path
    assert_response :ok

    assert_no_difference [ "User.count", "Organization.count" ] do
      post sign_up_path, params: {
        user: {
          name: "John",
          email: "johndoe@example.com",
          password: "pass"
        }
      }
    end

    assert_response :unprocessable_entity
    assert_select "p.is-danger", text: I18n.t("activerecord.errors.models.user.attributes.password.too_short")
  end

  test "sign up succeeds with matching password confirmation" do
    assert_difference "User.count", 1 do
      post sign_up_path, params: {
        user: {
          name: "Jane",
          email: "jane@example.com",
          password: "password123",
          password_confirmation: "password123"
        }
      }
    end

    assert_redirected_to root_path
  end

  test "sign up fails with non-matching password confirmation" do
    assert_no_difference "User.count" do
      post sign_up_path, params: {
        user: {
          name: "Jane",
          email: "jane@example.com",
          password: "password123",
          password_confirmation: "wrongpassword"
        }
      }
    end

    assert_response :unprocessable_entity
    assert_select "p.is-danger", text: I18n.t("activerecord.errors.models.user.attributes.password_confirmation.confirmation")
  end
end
