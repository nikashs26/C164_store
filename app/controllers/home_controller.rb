class HomeController < ApplicationController
  def index
    @featured_products = Product.includes(:category, :reviews).order(created_at: :desc).limit(6)
    @categories = Category.order(:name)
  end
end
