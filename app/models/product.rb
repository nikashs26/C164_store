class Product < ApplicationRecord
  belongs_to :category
  has_many :line_items, dependent: :restrict_with_error
  has_many :order_items, dependent: :restrict_with_error
  has_many :reviews, dependent: :destroy

  validates :name, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0 }
  validates :stock, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  scope :by_category, ->(category_id) { where(category_id: category_id) if category_id.present? }
  scope :search_by_name, ->(query) { where("name LIKE ?", "%#{query}%") if query.present? }

  def average_rating
    reviews.average(:rating)&.round(1)
  end

  def in_stock?
    stock.positive?
  end
end
