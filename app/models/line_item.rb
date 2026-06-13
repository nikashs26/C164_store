class LineItem < ApplicationRecord
  belongs_to :cart
  belongs_to :product

  validates :quantity, numericality: { only_integer: true, greater_than: 0 }
  validate :product_in_stock

  private

  def product_in_stock
    return if product.blank?

    if quantity.to_i > product.stock
      errors.add(:quantity, "exceeds available stock (#{product.stock})")
    end
  end
end
