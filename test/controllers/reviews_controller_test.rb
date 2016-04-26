require 'test_helper'

class ReviewsControllerTest < ActionController::TestCase
  setup do
    @admin_session = RailsIdentity::Session.new(user: users(:admin_one))
    @admin_session.save
    @admin_token = @admin_session.token
    @session = RailsIdentity::Session.new(user: users(:one))
    @session.save
    @token = @session.token
  end

  test "admin can list reviews for an image" do
    get :index, product_id: products(:one).uuid, token: @admin_token
    assert_response 200
  end
  
  test "user can list reviews" do
    get :index, product_id: products(:one).uuid, token: @token
    assert_response 200
  end

  test "cannot list reviews of non-existent product" do
    get :index, product_id: "doesnotexist", token: @token
    assert_response 404
  end

  test "admin can create review" do
    post :create, product_id: products(:three).uuid, feedback: "good good good good good", score: 3, token: @admin_token
    assert_response 201
  end

  test "admin cannot create review without score" do
    post :create, product_id: products(:one).uuid, feedback: "so so so so so so ", token: @admin_token
    assert_response 400
  end

  test "user can create review" do
    post :create, product_id: products(:three).uuid, feedback: "very very superb!!!!!!", score: 4, token: @token
    assert_response 201
  end

  test "admin user can show review" do
    get :show, id: "1", token: @admin_token
    assert_response 200
  end

  test "user can show review" do
    get :show, id: "1", token: @token
    assert_response 200
  end

  test "user cannot show non-existent review" do
    get :show, id: "doesnotexist", token: @token
    assert_response 404
  end

  test "admin can update review" do
    patch :update, id: "1", score: 4, token: @admin_token
    assert_response 200
  end

  test "user can update review" do
    patch :update, id: "1", score: 4, token: @token
    assert_response 200
  end

  test "admin cannot update review without a numeric score" do
    patch :update, id: "1", score: "abc", token: @token
    assert_response 400
  end

  test "admin can delete review" do
    delete :destroy, id: "1", token: @admin_token
    assert_response 204
  end

  test "user can delete review" do
    delete :destroy, id: "1", token: @token
    assert_response 204
  end

  test "user cannot delete other's review" do
    delete :destroy, id: "2", token: @token
    assert_response 401
  end
end
