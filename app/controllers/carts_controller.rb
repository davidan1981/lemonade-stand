class CartsController < ApplicationController

  ##
  # Show command for cart
  #
  def show
    @cart = Cart.find_by_uuid(params[:cart_id])
    render json: @cart, status: 200
  end
end
