class ProductsController < ApplicationController
  before_action :set_product, only: [ :show, :edit, :update, :destroy ]
  before_action :require_admin, only: [ :new, :create, :edit, :update, :destroy ]

  def index
    @categories = Category.order(:name)
    @products = Product.includes(:category, :reviews)
    @products = @products.search_by_name(params[:search])
    @products = @products.by_category(params[:category_id])
    @products = @products.order(:name)
  end

  def show
    @reviews = @product.reviews.includes(:user).order(created_at: :desc)
    @review = Review.new
  end

  def new
    @product = Product.new
    @categories = Category.order(:name)
  end

  def create
    @product = Product.new(product_params)
    @categories = Category.order(:name)
    if @product.save
      flash[:notice] = "Product created."
      redirect_to @product
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @categories = Category.order(:name)
  end

  def update
    @categories = Category.order(:name)
    if @product.update(product_params)
      flash[:notice] = "Product updated."
      redirect_to @product
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @product.destroy
    flash[:notice] = "Product deleted."
    redirect_to products_path
  end

  private

  def set_product
    @product = Product.find(params[:id])
  end

  def product_params
    params.require(:product).permit(:name, :description, :price, :stock, :image_url, :category_id)
  end
end
