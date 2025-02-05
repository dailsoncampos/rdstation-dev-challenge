class Cart < ApplicationRecord
  has_many :cart_items, dependent: :destroy

  validates :total_price, numericality: { greater_than_or_equal_to: 0 }

  before_save :update_total_price

  def total_price
    cart_items.sum(&:total_price)
  end

  def mark_as_abandoned
    update(abandoned: true) if last_interaction_at < 3.hours.ago
  end

  def remove_if_abandoned
    destroy if abandoned? && last_interaction_at < 7.days.ago
  end

  private

  def update_total_price
    self.total_price = total_price
  end
end
