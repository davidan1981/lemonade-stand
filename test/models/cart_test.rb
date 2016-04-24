require 'test_helper'

class CartTest < ActiveSupport::TestCase
  setup do
    @cart = carts(:one)
  end

  test "cart must belong to a user" do
    cart = Cart.new()
    assert_not cart.save()
    cart.user = users(:admin_one)
    assert cart.save()
  end

  test "cart cannot belong to user with cart" do
    cart = Cart.new(user_uuid: users(:one).uuid)
    assert_not cart.save()
  end

  test "cart calculates subtotal" do
    exp_subtotal = @cart.items.inject(0) { |t, i| t + i.subtotal }
    assert_equal exp_subtotal, @cart.subtotal
  end

  test "cart can delete an item" do
    @cart.items.destroy(@cart.items.last)
    assert @cart.save
    assert_equal 1, @cart.items.length
  end

  test "cart should not include duplicate products" do
    @cart.items << Item.new({
      product: products(:one),
      cart: @cart,
      quantity: 3
    })
    assert_not @cart.save()
  end

  test "cart calculates shipping for one item with a quantity > 1" do
    @cart.items.destroy(@cart.items.first)
    @cart.save()
    item = @cart.items.first
    exp_shipping = item.product.add_on_shipping * item.quantity
    assert_equal exp_shipping, @cart.shipping
  end

  test "cart calculates shipping for one item with a quantity = 1" do
    @cart.items.destroy(@cart.items.last)
    @cart.save()
    exp_shipping = @cart.items.first.product.base_shipping * 1
    assert_equal exp_shipping, @cart.shipping
  end

  test "cart calculates shipping for multiple items" do
    exp_shipping = @cart.items.inject(0) { |t, i| 
      t + i.product.add_on_shipping * i.quantity
    }
    assert_equal exp_shipping, @cart.shipping
  end

end
