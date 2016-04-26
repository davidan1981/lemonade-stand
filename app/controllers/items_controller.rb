##
# Items controller is the heart of carts and orders. Although they house
# items, items are what make carts and orders what they are.
#
# It is assumed that the front-end app will handle unauthenticated cart and
# item edits. However, once the user is authenticated or an order is placed,
# then items are tracked on the server-side. Therefore, all actions require
# a token.
#
class ItemsController < ApplicationController

  prepend_before_action :require_token, except: [:options]
  before_action :get_item, only: [:show, :update, :destroy]

  ##
  # List all items either in a cart or in an order. 
  #
  def index
    if params[:cart_id]
      get_cart
      @items = Item.where(cart: @cart)
    elsif params[:order_id]
      get_order
      @items = Item.where(order: @order)
    end
    render json: @items, status: 200
  end

  ##
  # Creates a new item for a cart. The controller only allows item creation
  # for a cart and not for an order. The latter occurs when the order is
  # made from a cart.
  #
  def create
    cart_uuid = params[:cart_id]
    @item = Item.new(item_params.merge(cart_uuid: cart_uuid))
    if @item.save
      render json: @item, status: 201
    else
      render_errors 400, @item.errors.full_messages
    end
  end

  ##
  # Shows an item
  #
  def show
    render json: @item, status: 200
  end

  ##
  # Updates an item
  #
  def update
    if @item.update_attributes(item_params)
      render json: @item, status: 200
    else
      render_errors 400, @item.errors.full_messages
    end
  end

  ##
  # Deletes and item
  #
  def destroy
    if @item.destroy
      render body: '', status: 204
    else
      # :nocov:
      render_error 400, @item.errors.full_messages
      # :nocov:
    end
  end

  private

    ##
    # Authorize the authenticated user an access to the specified object. If
    # the user has no permission, raises an error.
    #
    def authorize_access_to(obj)
      unless authorized?(obj)
        raise Repia::Errors::Unauthorized
      end
    end

    def get_cart
      @cart = Cart.find_by_uuid(params[:cart_id])
      authorize_access_to(@cart)
      return @cart
    end

    def get_order
      @order = Order.find_by_uuid(params[:order_id])
      authorize_access_to(@order)
      return @order
    end

    def get_item
      @item = Item.find_by_uuid(params[:id])
      if @item.nil?
        raise Repia::Errors::NotFound
      elsif @item.cart.present?
        authorize_access_to(@item.cart)
      elsif @item.order.present?
        authorize_access_to(@item.order)
      end
      return @item
    end

    def item_params
      params.permit(:product_uuid, :quantity)
    end

end
