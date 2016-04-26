require 'test_helper'

class ItemsControllerTest < ActionController::TestCase
  setup do
    @admin_session = RailsIdentity::Session.new(user: users(:admin_one))
    @admin_session.save
    @admin_token = @admin_session.token
    @session = RailsIdentity::Session.new(user: users(:one))
    @session.save
    @token = @session.token
  end

  test "user can list cart items" do
    get :index, cart_id: carts(:one).uuid, token: @token
    assert_response 200
  end

  test "user can list order items" do
    @order = Order.from_cart(carts(:one))
    @order.save
    get :index, order_id: @order.uuid, token: @token
    assert_response 200
  end

  test "user create cart item" do
    post :create, cart_id: carts(:two).uuid, product_uuid: products(:one).uuid, quantity: 1, token: @token
    assert_response 201
  end

  test "cannot create item without quantity" do
    post :create, cart_id: carts(:two).uuid, product_uuid: products(:one).uuid, token: @token
    assert_response 400
  end

  test "user can show item" do
    get :show, id: items(:one).uuid, token: @token
    assert_response 200
  end

  test "user can show item after moved to order" do
    @order = Order.from_cart(carts(:one))
    @order.save
    item = items(:one)
    assert_nil item.cart
    get :show, id: items(:one).uuid, token: @token
    assert_response 200
  end

  test "cannot show non-existent item" do
    get :show, id: "doesnotexist", token: @token
    assert_response 404
  end

  test "user can update item" do 
    patch :update, id: items(:one).uuid, quantity: 3, token: @token
    assert_response 200
  end

  test "user cannot update other's item" do
    patch :update, id: items(:three).uuid, quantity: 2, token: @token
    assert_response 401
  end

  test "cannot update item with quantity < 1" do 
    patch :update, id: items(:one).uuid, quantity: 0, token: @token
    assert_response 400
  end

  test "admin can update other's item" do 
    patch :update, id: items(:one).uuid, quantity: 3, token: @admin_token
    assert_response 200
  end

  test "user can destroy item" do
    delete :destroy, id: items(:one).uuid, token: @token
    assert_response 204
  end

  test "cannot destroy item without token" do
    delete :destroy, id: items(:one).uuid
    assert_response 401
  end

  test "admin can destroy item" do
    delete :destroy, id: items(:one).uuid, token: @admin_token
    assert_response 204
  end

end
