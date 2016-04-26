##
# Product images controller handles images for products. Only admin can
# create, update, and delete. But, of course, anybody can list and show.
#
class ProductImagesController < ApplicationController
  prepend_before_action :accept_token, only: [:index, :show]
  prepend_before_action :require_admin_token, only: [:create, :update,
                                                     :destroy]
  before_action :get_product, only: [:index, :create]
  before_action :get_product_image, only: [:show, :update, :destroy]

  ##
  # Lists all product images that belong to a product.
  #
  def index
    @product_images = ProductImage.where(product_uuid: params[:product_id])
    render json: @product_images, status: 200
  end

  ##
  # Creates a new product image for a product.
  #
  def create
    create_params = product_image_params || {product_uuid: @product.uuid}
    @product_image = ProductImage.new(product_image_params)
    if @product_image.save
      render json: @product_image, status: 201
    else
      render_error 400, @product_image.errors.full_messages
    end
  end

  ##
  # Shows a product image.
  #
  def show
    render json: @product, status: 200
  end

  ##
  # Updates a product image
  #
  def update
    if @product_image.update_attributes(product_image_params)
      render json: @product_image, status: 200
    else
      render_error 400, @product_image.errors.full_messages
    end
  end

  ## 
  # Deletes a product image
  #
  def destroy
    if @product_image.destroy 
      render body: "", status: 204
    else
      # :nocov:
      render_error 400, @product_image.errors.full_messages
      # :nocov:
    end
  end

  private

    ##
    # Retrieves the specified product. No need to authorize.
    #
    def get_product
      @product = Product.find_by_uuid(params[:product_id])
      if @product.nil?
        raise Repia::Errors::NotFound
      end
    end

    ## 
    # Retrieves the specified product image. No need to authorize.
    #
    def get_product_image
      @product_image = ProductImage.find_by_uuid(params[:id])
      if @product_image.nil?
        raise Repia::Errors::NotFound
      end
    end

    def product_image_params
      params.permit(:url, :metadata)
    end

end
