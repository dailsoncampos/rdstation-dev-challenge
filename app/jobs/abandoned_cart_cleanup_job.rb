class AbandonedCartCleanupJob < ApplicationJob
  queue_as :default

  def perform
    Cart.where("updated_at < ?", 3.hours.ago).update_all(abandoned: true)
    Cart.where("updated_at < ? AND abandoned = ?", 7.days.ago, true).destroy_all
  end
end