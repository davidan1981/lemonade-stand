##
# Reviews controller manages user reviews for products. Only authenticated
# user can leave a feedback. But anybody can list and see. For update and
# delete, the user must have authorization to do so.
#
class ReviewsController < ApplicationController

  prepend_before_action :require_token, only: [:create, :update, :destroy]
  before_action :get_product, only: [:index, :create]
  before_action :get_review, only: [:show, :update, :destroy]
  before_action :authorize_access, only: [:update, :destroy]

  def index
    @reviews = Review.where(product_uuid: params[:product_id])
    render json: @reviews, status: 200
  end

  def create
    create_params = review_params
    create_params[:product_uuid] = @product.uuid
    create_params[:user_uuid] = @auth_user.uuid
    @review = Review.new(create_params)
    if @review.save
      render json: @review, status: 201
    else
      render_error 400, @review.errors.full_messages
    end
  end

  def show
    render json: @product, status: 200
  end

  def update
    if @review.update_attributes(review_params)
      render json: @review, status: 200
    else
      render_error 400, @review.errors.full_messages
    end
  end

  def destroy
    if @review.destroy 
      render body: "", status: 204
    else
      # :nocov:
      render_error 400, @review.errors.full_messages
      # :nocov:
    end
  end

  private

    def authorize_access
      unless authorized?(@review)
        raise Repia::Errors::Unauthorized
      end
    end

    def get_product
      @product = Product.find_by_uuid(params[:product_id])
      if @product.nil?
        raise Repia::Errors::NotFound
      end
    end

    def get_review
      @review = Review.find_by_uuid(params[:id])
      if @review.nil?
        raise Repia::Errors::NotFound
      end
    end

    def review_params
      params.permit(:feedback, :score, :metadata)
    end
end
