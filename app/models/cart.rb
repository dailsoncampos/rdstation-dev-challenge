class Cart < ApplicationRecord
  has_many :cart_items, dependent: :destroy

  validates :total_price, numericality: { greater_than_or_equal_to: 0 }

  before_validation :update_last_interaction_at, on: [:create, :update]

  def total_price
    cart_items.sum(&:total_price)
  end

  def mark_as_abandoned
    update!(abandoned: true) if !abandoned? && last_interaction_at && last_interaction_at < 3.hours.ago
  end

  def remove_if_abandoned
    destroy! if abandoned? && last_interaction_at && last_interaction_at < 7.days.ago
  end

  def add_product(product, quantity)
    return nil if quantity.nil? || quantity <= 0
  
    cart_item = cart_items.find_or_initialize_by(product: product)
    cart_item.quantity = (cart_item.quantity.presence || 0) + quantity
    cart_item.save!
  
    cart_item
  end

  private

  def update_last_interaction_at
    self.last_interaction_at = Time.current
  end
end
