class OrdersController < ApplicationController
  before_action :require_login
  before_action :set_order, only: [ :show ]

  def index
    if current_user.admin?
      @orders = Order.includes(:user, :order_items).order(created_at: :desc)
    else
      @orders = current_user.orders.includes(:order_items).order(created_at: :desc)
    end
  end

  def show
    authorize_order!
  end

  def create
    cart = current_user.cart
    if cart.nil? || cart.line_items.empty?
      flash[:alert] = "Your cart is empty."
      return redirect_to cart_path
    end

    order = nil
    Order.transaction do
      order = current_user.orders.create!(total: cart.total, status: "completed")
      cart.line_items.includes(:product).each do |item|
        product = item.product
        raise ActiveRecord::Rollback if item.quantity > product.stock

        order.order_items.create!(
          product: product,
          quantity: item.quantity,
          unit_price: product.price
        )
        product.decrement!(:stock, item.quantity)
      end
      cart.line_items.destroy_all
    end

    if order&.persisted?
      flash[:notice] = "Order placed successfully!"
      redirect_to order
    else
      flash[:alert] = "Unable to complete checkout. Please check stock levels."
      redirect_to cart_path
    end
  end

  private

  def set_order
    @order = Order.includes(order_items: :product).find(params[:id])
  end

  def authorize_order!
    return if current_user.admin? || @order.user_id == current_user.id

    flash[:alert] = "You are not authorized to view this order."
    redirect_to orders_path
  end
end
