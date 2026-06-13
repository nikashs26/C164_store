class CategoriesController < ApplicationController
  before_action :require_admin
  before_action :set_category, only: [ :edit, :update, :destroy ]

  def index
    @categories = Category.includes(:products).order(:name)
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      flash[:notice] = "Category created."
      redirect_to categories_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @category.update(category_params)
      flash[:notice] = "Category updated."
      redirect_to categories_path
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @category.products.any?
      flash[:alert] = "Cannot delete a category that has products."
      redirect_to categories_path
    else
      @category.destroy
      flash[:notice] = "Category deleted."
      redirect_to categories_path
    end
  end

  private

  def set_category
    @category = Category.find(params[:id])
  end

  def category_params
    params.require(:category).permit(:name, :description)
  end
end
