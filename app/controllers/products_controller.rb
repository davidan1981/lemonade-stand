##
# Products controller is probably the main functionality of the app.
# Althouth they can be listed and viewed publicly, only admins are allowed
# to create, update, and destroy.
#
class ProductsController < ApplicationController
  prepend_before_action :accept_token, only: [:index, :show]
  prepend_before_action :require_admin_token, only: [:create, :update, :destroy]
  before_action :get_product, only: [:show, :update, :destroy]

  ##
  # Lists all products. This action is wide open.
  #
  def index
    @products = Product.all
    render json: @products, status: 200
  end

  ##
  # Creates a new product. Only admin should perform this action.
  #
  def create
    @product = Product.new(product_params)
    if @product.save
      render json: @product, status: 201
    else
      render_errors 400, @product.errors.full_messages
    end
  end

  ##
  # Shows a product. Wide open.
  #
  def show
    render json: @product, status: 200
  end

  ##
  # Updates a product. Only admin can do this.
  #
  def update
    if @product.update_attributes(product_params)
      render json: @product
    else
      render_errors 400, @product.errors.full_messages
    end
  end

  ##
  # Deletes a product. Only admin can do this.
  #
  def destroy
    if @product.destroy
      render body: '', status: 204
    else
      # :nocov:
      render_error 400, @product.errors.full_messages
      # :nocov:
    end
  end

  private

    ##
    # Retrieves the specified product. No need to check authorization.
    #
    def get_product
      @product = Product.find_by_uuid(params[:id])
      if @product.nil?
        raise Repia::Errors::NotFound, "Product #{params[:id]} is not found"
      end
    end

    def product_params
      params.permit(:enabled, :title, :summary, :description, :quantity,
                    :orig_price, :sale_price, :base_shipping, :add_on_shipping,
                    :metadata)
    end

end
