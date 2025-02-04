require 'rails_helper'

RSpec.describe AbandonedCartCleanupJob, type: :job do
  let!(:old_cart) { create(:cart, created_at: 8.days.ago, updated_at: 8.days.ago) }
  let!(:recent_cart) { create(:cart, created_at: 1.hour.ago, updated_at: 1.hour.ago) }
  let!(:product) { create(:product) }

  before do
    create(:cart_item, cart: old_cart, product: product, quantity: 1)
    create(:cart_item, cart: recent_cart, product: product, quantity: 1)
  end

  it "removes carts older than 7 days" do
    expect { described_class.perform_now }.to change { Cart.count }.by(-1)
  end

  it "does not remove carts that are less than 7 days old" do
    described_class.perform_now
    expect(Cart.exists?(recent_cart.id)).to be_truthy
  end
end