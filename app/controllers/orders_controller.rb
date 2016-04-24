class OrdersController < ApplicationController
  prepend_before_action :require_admin_token, only: [:index]
  prepend_before_action :require_token, except: [:options, :index]
  before_action :get_order, only: [:show, :destroy]
  before_action :process_billing, only: [:create]

  def index
    @orders = Order.all
    render json: @orders, status: 200
  end

  def create
    cart = Cart.find_by_uuid(params[:cart_uuid])
    if cart.nil? || cart.user != @auth_user
      raise Repia::Errors::BadRequest
    end
    @order = Order.from_cart(cart)
    if @order.save
      render json: @order, status: 201
    else
      # :nocov:
      render_error 400, @order.errors.full_messages
      # :nocov:
    end
  end

  def show
    render json: @order
  end

  def destroy
    if @order.destroy
      render body: "", status: 204
    else
      # :nocov:
      render_error 500, "Could not delete order #{@order.uuid}"
      # :nocov:
    end
  end

  private

    def process_billing
      # Magic here
    end

    def get_order
      @order = Order.find_by_uuid(params[:id])
      if @order.nil?
        raise Repia::Errors::NotFound
      end
    end

end
