require 'test_helper'

class ProductImagesControllerTest < ActionController::TestCase
  setup do
    @admin_session = RailsIdentity::Session.new(user: users(:admin_one))
    @admin_session.save
    @admin_token = @admin_session.token
    @session = RailsIdentity::Session.new(user: users(:one))
    @session.save
    @token = @session.token
  end

  test "admin can list product images for an image" do
    get :index, product_id: products(:one).uuid, token: @admin_token
    assert_response 200
  end
  
  test "user can list product images" do
    get :index, product_id: products(:one).uuid, token: @token
    assert_response 200
  end

  test "cannot list product images of non-existent product" do
    get :index, product_id: "doesnotexist", token: @token
    assert_response 404
  end

  test "admin can create product image" do
    post :create, product_id: products(:one).uuid, url: "google.com", token: @admin_token
    assert_response 201
  end

  test "admin cannot create product image without url" do
    post :create, product_id: products(:one).uuid, token: @admin_token
    assert_response 400
  end

  test "user cannot create product image" do
    post :create, product_id: products(:one).uuid, token: @token
    assert_response 401
  end

  test "admin user can show product image" do
    get :show, id: "1", token: @admin_token
    assert_response 200
  end

  test "user can show product image" do
    get :show, id: "1", token: @token
    assert_response 200
  end

  test "user cannot show non-existent product image" do
    get :show, id: "doesnotexist", token: @token
    assert_response 404
  end

  test "admin can update product image" do
    patch :update, id: "1", url: "yahoo.com", token: @admin_token
    assert_response 200
  end

  test "user cannot update product image" do
    patch :update, id: "1", url: "yahoo.com", token: @token
    assert_response 401
  end

  test "admin cannot update product image without url" do
    patch :update, id: "1", url: nil, token: @admin_token
    assert_response 400
  end

  test "admin can delete product image" do
    delete :destroy, id: "1", token: @admin_token
    assert_response 204
  end

  test "user cannot delete product image" do
    delete :destroy, id: "1", token: @token
    assert_response 401
  end

end
