class Cart < ApplicationRecord
  has_many :cart_items, dependent: :destroy
  validates_numericality_of :total_price, greater_than_or_equal_to: 0

  def total_price
    cart_items.sum(&:total_price)
  end
end
