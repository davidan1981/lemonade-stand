require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "user always has a cart" do
    user = User.new(username: "new@example.com", password: "secretsecret", password_confirmation: "secretsecret")
    assert_not_nil user.cart
  end
end
