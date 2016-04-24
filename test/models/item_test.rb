require 'test_helper'

class ItemTest < ActiveSupport::TestCase
  setup do
    @item_base_args = {
      product: products(:one),
      cart: carts(:one),
      quantity: 2,
    }
  end

  test "item must have a quantity > 0" do
    args = @item_base_args.clone()
    args[:quantity] = 0
    item = Item.new(args)
    assert_not item.save()
  end

  test "item calculates subtotal of line item" do
    item = Item.new(@item_base_args)
    assert (products(:one).sale_price * item.quantity) == item.subtotal
  end

  test "item must belong to a product" do
    args = @item_base_args.clone()
    args.delete(:product)
    item = Item.new(args)
    assert_not item.save()
    item = Item.new(@item_base_args)
    assert item.save()
  end

  test "item must belong to either a cart or an order but not both" do
    args = @item_base_args.clone()
    args.delete(:cart)
    item = Item.new(args)
    assert_not item.save()
    args = @item_base_args.clone()
    args.delete(:cart)
    item = Item.new(args)
    assert_not item.save()
    args = @item_base_args.clone()
    args[:order] = orders(:one)
    item = Item.new(args)
    assert_not item.save()
    args = @item_base_args.clone()
    args.delete(:cart)
    args[:order] = orders(:one)
    item = Item.new(args)
    assert item.save()
  end

end
