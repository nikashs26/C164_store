class Cart < ApplicationRecord
  belongs_to :user
  has_many :line_items, dependent: :destroy
  has_many :products, through: :line_items

  def total
    line_items.includes(:product).sum { |item| item.product.price * item.quantity }
  end

  def item_count
    line_items.sum(:quantity)
  end

  def add_product(product, quantity = 1)
    item = line_items.find_or_initialize_by(product: product)
    item.quantity = (item.quantity || 0) + quantity
    item.save!
  end
end
