class CartAbandonmentService
  def self.call
    Cart.where("last_interaction_at < ?  AND abandoned = ?", 3.hours.ago, false).find_each do |cart|
      cart.update!(abandoned: true)
    end

    Cart.where("last_interaction_at < ? AND abandoned = ?", 7.days.ago, true).find_each(&:destroy!)
  end
end
