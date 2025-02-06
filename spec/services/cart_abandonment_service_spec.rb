require 'rails_helper'

RSpec.describe CartAbandonmentService, type: :service do
  let!(:old_cart) { create(:cart, last_interaction_at: 8.days.ago, abandoned: false) }
  let!(:recent_cart) { create(:cart, last_interaction_at: 1.hour.ago, abandoned: false) }
  let!(:abandoned_cart) { create(:cart, last_interaction_at: 8.days.ago, abandoned: true) }

  describe '.call' do
    context "marking carts as abandoned" do
      xit "marks carts as abandoned if inactive for more than 3 hours" do
        expect {
          described_class.call
          old_cart.reload
        }.to change(old_cart, :abandoned).from(false).to(true)
      end

      it "does not mark carts as abandoned if active within 3 hours" do
        expect {
          described_class.call
          recent_cart.reload
        }.not_to change(recent_cart, :abandoned)
      end

      it "does not mark carts as abandoned if already abandoned" do
        expect {
          described_class.call
          abandoned_cart.reload
        }.not_to change(abandoned_cart, :abandoned)
      end
    end

    context "removing abandoned carts" do
      xit "removes carts abandoned for more than 7 days" do
        abandoned_cart.update(last_interaction_at: 8.days.ago)
        expect {
          described_class.call
        }.to change { Cart.count }.by(-1)
      end

      it "does not remove carts abandoned for less than 7 days" do
        abandoned_cart.update(last_interaction_at: 6.days.ago)
        expect {
          described_class.call
        }.not_to change { Cart.count }
      end
    end
  end
end
