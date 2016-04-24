class ProductsController < ApplicationController
  prepend_before_action :require_token, only: [:index, :show]
  prepend_before_action :require_admin_token, only: [:create, :update, :destroy]
  before_action :get_product, only: [:update, :destroy]

  def index
    @products = Product.all
    render json: @products
  end

  def create
    @product = Product.new(product_params)
    if @product.save
      render json: @product, status: 201
    else
      render_errors 400, @product.errors.full_messages
    end
  end

  def show
    render json: @product
  end

  def update
    if @product.update_attributes(product_params)
      render json: @product
    else
      render_errors 400, @product.errors.full_messages
    end
  end

  def destroy
    if @product.destroy
      render body: '', status: 204
    else
      # :nocov:
      raise Repia::Errors::InternalServerError, 
            "Could not delete product #{params[:id]}"
      # :nocov:
    end
  end

  private

    def get_product
      @product = Product.find_by_uuid(params[:id])
      if @product.nil?
        raise Repia::Errors::NotFound, "Product #{params[:id]} is not found"
      end
    end

    def product_params
      params.permit(:enabled, :title, :summary, :description, :quantity,
                    :orig_price, :sale_price, :base_shipping, :add_on_shipping)
    end

end
