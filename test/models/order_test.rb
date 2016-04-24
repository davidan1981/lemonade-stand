require 'test_helper'

class OrderTest < ActiveSupport::TestCase

  test "order is created from a cart" do
    order = Order.from_cart(carts(:one))
    assert 2 == order.items.length
  end

end
