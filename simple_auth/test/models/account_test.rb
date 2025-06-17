require "test_helper"

class AccountTest < ActiveSupport::TestCase
  test "should create account" do
    account = Account.new(name: "Checking")
    assert account.save
  end

  test "should not create account without name" do
    account = Account.new(name: nil)
    assert_not account.save
  end
end
