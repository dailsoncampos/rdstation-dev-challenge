require 'rails_helper'

RSpec.describe Cart, type: :model do
  context 'when validating' do
    it 'validates numericality of total_price' do
      cart = described_class.new(total_price: -1)
      expect(cart.valid?).to be_falsey
      expect(cart.errors[:total_price]).to include("must be greater than or equal to 0")
    end
  end

  describe 'mark_as_abandoned' do
    let(:shopping_cart) { create(:cart) }

    xit 'marks the shopping cart as abandoned if inactive for more than 3 hours' do
      shopping_cart.update(last_interaction_at: 4.hours.ago)
      expect { shopping_cart.mark_as_abandoned }.to change { shopping_cart.reload.abandoned? }.from(false).to(true)
    end

    it 'does not mark the shopping cart as abandoned if active within 3 hours' do
      shopping_cart.update(last_interaction_at: 2.hours.ago)
      expect { shopping_cart.mark_as_abandoned }.not_to change { shopping_cart.reload.abandoned? }
    end

    it 'does not mark the shopping cart as abandoned if already abandoned' do
      shopping_cart.update(last_interaction_at: 4.hours.ago, abandoned: true)
      expect { shopping_cart.mark_as_abandoned }.not_to change { shopping_cart.reload.abandoned? }
    end
  end

  describe 'remove_if_abandoned' do
    let(:shopping_cart) { create(:cart, last_interaction_at: 8.days.ago, abandoned: true) }

    xit 'removes the shopping cart if abandoned for more than 7 days' do
      expect { shopping_cart.remove_if_abandoned }.to change { Cart.count }.by(-1)
    end

    it 'does not remove the shopping cart if abandoned for less than 7 days' do
      shopping_cart.update(last_interaction_at: 6.days.ago)
      expect { shopping_cart.remove_if_abandoned }.not_to change { Cart.count }
    end

    it 'does not remove the shopping cart if not abandoned' do
      shopping_cart.update(abandoned: false)
      expect { shopping_cart.remove_if_abandoned }.not_to change { Cart.count }
    end
  end
end