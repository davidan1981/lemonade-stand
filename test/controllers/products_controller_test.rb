require 'test_helper'

class ProductsControllerTest < ActionController::TestCase
  setup do
    @admin_session = RailsIdentity::Session.new(user: users(:admin_one))
    @admin_session.save
    @admin_token = @admin_session.token
    @session = RailsIdentity::Session.new(user: users(:one))
    @session.save
    @token = @session.token
  end

  test "user can list products" do
    get :index, token: @token
    assert_response :success
    all_products = Product.all
    assert_equal all_products.length, assigns(:products).length
  end

  test "admin can list products" do
    get :index, token: @admin_token
    assert_response :success
    all_products = Product.all
    assert_equal all_products.length, assigns(:products).length
  end

  test "public can list products" do
    get :index
    assert_response 200
  end

  test "user can show product" do
    get :show, id: 1, token: @token
    assert_response :success
  end

  test "public can show product" do
    get :show, id: 1
    assert_response 200
  end

  test "admin can create a product" do
    post :create, token: @admin_token, enabled: true, title: "Foo",
         description: "bar", quantity: 1, orig_price: 1000,
         sale_price: 800, base_shipping: 200, add_on_shipping: 100
    assert_response 201
  end

  test "cannot create a product without title" do
    post :create, token: @admin_token, enabled: true,
         description: "bar", quantity: 1, orig_price: 1000,
         sale_price: 800, base_shipping: 200, add_on_shipping: 100
    assert_response 400
  end

  test "user cannot create a product" do
    post :create, token: @token, enabled: true, title: "Foo",
         description: "bar", quantity: 1, orig_price: 1000,
         sale_price: 800, base_shipping: 200, add_on_shipping: 100
    assert_response 401
  end

  test "admin can update product" do
    patch :update, id:1, token: @admin_token, title: "Bar"
    assert_response 200
  end

  test "cannot update product with a null title" do
    patch :update, id:1, token: @admin_token, title: nil
    assert_response 400
  end

  test "user cannot update product" do
    patch :update, id: 1, token: @token
    assert_response 401
  end

  test "admin can delete product" do
    delete :destroy, id: 1, token: @admin_token
    assert_response 204
  end

  test "admin cannot delete non-existent product" do
    delete :destroy, id: "doesnotexist", token: @admin_token
    assert_response 404
  end


end
