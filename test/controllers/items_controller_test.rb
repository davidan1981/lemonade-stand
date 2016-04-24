require 'test_helper'

class ItemsControllerTest < ActionController::TestCase
  setup do
    @admin_session = RailsIdentity::Session.new(user: users(:admin_one))
    @admin_session.save
    @admin_token = @admin_session.token
    @session = RailsIdentity::Session.new(user: users(:one))
    @session.save
    @token = @session.token
    @order = Order.from_cart(carts(:one))
    @order.save
  end

  test "list cart items" do
    get :index, cart_id: "1", token: @token
    assert_response 200
  end

  test "list order items" do
    get :index, order_id: @order.uuid, token: @token
    assert_response 200
  end

  test "create a cart item" do
    post :create, cart_id: carts(:two).uuid, product_uuid: products(:one).uuid, quantity: 1, token: @token
    assert_response 201
  end

  test "create an order item" do
    post :create, order_id: orders(:two).uuid, product_uuid: products(:one).uuid, quantity: 1, token: @token
    assert_response 201
  end

  test "cannot create an order item without quantity" do
    post :create, order_id: orders(:two).uuid, product_uuid: products(:one).uuid, token: @token
    assert_response 400
  end

  test "show item" do
    get :show, id: items(:one).uuid, token: @token
    assert_response 200
  end

  test "cannot show non-existent item" do
    get :show, id: "doesnotexist", token: @token
    assert_response 404
  end

  test "update item" do 
    patch :update, id: items(:one).uuid, quantity: 3, token: @token
    assert_response 200
  end

  test "cannot update item with quantity < 1" do 
    patch :update, id: items(:one).uuid, quantity: 0, token: @token
    assert_response 400
  end

  test "destroy item" do
    delete :destroy, id: items(:one).uuid, token: @token
    assert_response 204
  end

  test "cannot destroy item without token" do
    delete :destroy, id: items(:one).uuid
    assert_response 401
  end
end
