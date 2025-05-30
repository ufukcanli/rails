require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "password must be at least 8 characters" do
    invalid_password = "a" * (User::MINIMUM_PASSWORD_LENGTH - 1)
    user = User.new email: "test@mail.com", password: invalid_password

    assert_not user.valid?
    assert_includes user.errors.full_messages, "Password is too short (minimum is 8 characters)"
  end

  test "password must be present" do
    user = User.new email: "test@mail.com", password: ""

    assert_not user.valid?
    assert_includes user.errors.full_messages, "Password can't be blank"
  end
end
