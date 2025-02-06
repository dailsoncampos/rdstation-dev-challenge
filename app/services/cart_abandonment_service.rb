class CartAbandonmentService
  def self.call
    Cart.where("last_interaction_at < ?", 3.hours.ago).find_each do |cart|
      cart.update!(abandoned: true)
    end

    Cart.where("last_interaction_at < ? AND abandoned = ?", 7.days.ago, true).find_each(&:destroy!)
  end
end
