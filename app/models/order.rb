class Order < ApplicationRecord
  belongs_to :user
  has_many :order_items, dependent: :destroy
  has_many :products, through: :order_items

  validates :status, presence: true
  validates :total, numericality: { greater_than_or_equal_to: 0 }

  def self.statuses
    %w[pending completed cancelled]
  end
end
