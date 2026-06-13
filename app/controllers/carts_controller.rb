class CartsController < ApplicationController
  before_action :require_login
  before_action :set_cart

  def show
    @line_items = @cart.line_items.includes(:product)
  end

  def add_item
    product = Product.find(params[:product_id])
    unless product.in_stock?
      flash[:alert] = "This product is out of stock."
      return redirect_to product
    end

    @cart.add_product(product, params[:quantity].to_i.clamp(1, product.stock))
    flash[:notice] = "#{product.name} added to cart."
    redirect_to product
  rescue ActiveRecord::RecordInvalid => e
    flash[:alert] = e.record.errors.full_messages.to_sentence
    redirect_to product
  end

  def update_item
    item = @cart.line_items.find(params[:line_item_id])
    quantity = params[:quantity].to_i
    if quantity <= 0
      item.destroy
      flash[:notice] = "Item removed from cart."
    elsif item.update(quantity: quantity)
      flash[:notice] = "Cart updated."
    else
      flash[:alert] = item.errors.full_messages.to_sentence
    end
    redirect_to cart_path
  end

  def remove_item
    item = @cart.line_items.find(params[:line_item_id])
    item.destroy
    flash[:notice] = "Item removed from cart."
    redirect_to cart_path
  end

  private

  def set_cart
    @cart = current_user.cart || current_user.create_cart!
  end
end
