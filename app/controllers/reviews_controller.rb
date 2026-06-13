class ReviewsController < ApplicationController
  before_action :require_login
  before_action :set_product
  before_action :set_review, only: [ :edit, :update, :destroy ]
  before_action :authorize_review!, only: [ :edit, :update, :destroy ]

  def create
    @review = current_user.reviews.build(review_params.merge(product: @product))
    if @review.save
      flash[:notice] = "Review submitted."
      redirect_to @product
    else
      flash[:alert] = @review.errors.full_messages.to_sentence
      redirect_to @product
    end
  end

  def edit
  end

  def update
    if @review.update(review_params)
      flash[:notice] = "Review updated."
      redirect_to @product
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @review.destroy
    flash[:notice] = "Review deleted."
    redirect_to @product
  end

  private

  def set_product
    @product = Product.find(params[:product_id])
  end

  def set_review
    @review = @product.reviews.find(params[:id])
  end

  def authorize_review!
    return if @review.user_id == current_user.id

    flash[:alert] = "You can only edit or delete your own reviews."
    redirect_to @product
  end

  def review_params
    params.require(:review).permit(:rating, :comment)
  end
end
