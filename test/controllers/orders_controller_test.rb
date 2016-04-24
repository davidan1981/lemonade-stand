require 'test_helper'

class OrdersControllerTest < ActionController::TestCase
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

  test "admin can list (active) orders" do
    get :index, token: @admin_token
    assert_response 200
  end

  test "user cannot list any orders" do
    get :index, token: @token
    assert_response 401
  end

  test "user can create order from a cart" do
    post :create, cart_uuid: carts(:one).uuid, token: @token
    assert_response 201
  end

  test "user cannot create order from invalid cart" do
    post :create, cart_uuid: "doesnotexist", token: @token
    assert_response 400
  end

  test "show order" do
    get :show, id: orders(:one).uuid, token: @token
    assert_response 200
  end

  test "cannot show non-existent order" do
    get :show, id: "doesnotexist", token: @token
    assert_response 404
  end

  test "user destroy order" do
    delete :destroy, id: orders(:one).uuid, token: @token
    assert_response 204
  end

  test "cannot destroy order without token" do
    delete :destroy, id: orders(:one).uuid
    assert_response 401
  end
end
