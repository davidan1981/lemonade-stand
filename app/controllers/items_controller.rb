class ItemsController < ApplicationController
  prepend_before_action :require_token, except: [:options]
  before_action :get_item, only: [:show, :update, :destroy]

  def index
    # You cannot have both cart_id and order_id period. Use either.
    cart_uuid = params[:cart_id]
    order_uuid = params[:order_id]

    if cart_uuid
      @items = Item.where(cart_uuid: cart_uuid)
    elsif order_uuid
      @items = Item.where(order_uuid: order_uuid)
    end
    render json: @items
  end

  def create
    cart_uuid = params[:cart_id]
    order_uuid = params[:order_id]

    if cart_uuid
      @item = Item.new(item_params.merge(cart_uuid: cart_uuid))
    elsif order_uuid
      @item = Item.new(item_params.merge(order_uuid: order_uuid))
    end
    
    if @item.save
      render json: @item, status: 201
    else
      render_errors 400, @item.errors.full_messages
    end
  end

  def show
    render json: @item
  end

  def update
    if @item.update_attributes(item_params)
      render json: @item
    else
      render_errors 400, @item.errors.full_messages
    end
  end

  def destroy
    if @item.destroy
      render body: '', status: 204
    else
      # :nocov:
      render_error 500, "Could not delete item #{@item.uuid}"
      # :nocov:
    end
  end

  private

    def get_item
      @item = Item.find_by_uuid(params[:id])
      if @item.nil?
        raise Repia::Errors::NotFound
      end
    end

    def item_params
      params.permit(:product_uuid, :quantity)
    end

end
