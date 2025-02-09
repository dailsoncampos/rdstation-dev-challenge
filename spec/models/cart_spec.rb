require 'rails_helper'

RSpec.describe Cart, type: :model do
  let(:cart) { create(:cart) }
  let(:product) { create(:product, price: 20.0) }

  describe "#total_price" do
    it "correctly calculates the total price of the cart" do
      cart = create(:cart)
      create(:cart_item, cart: cart, quantity: 3, product: create(:product, price: 20.0))
      cart.reload
      expect(cart.total_price).to eq(60.0)
    end
  end

  describe "#add_product" do
    it "adds a product to the cart" do
      cart.add_product(product, 2)
      expect(cart.cart_items.count).to eq(1)
      expect(cart.cart_items.first.quantity).to eq(2)
    end

    it "increments the quantity if the product already exists" do
      cart = create(:cart)
      product = create(:product)
      create(:cart_item, cart: cart, product: product, quantity: 2)
    
      cart.add_product(product, 3)
      cart.reload
    
      expect(cart.cart_items.first.quantity).to eq(5)
    end

    it "does not allow adding zero or negative quantity" do
      expect(cart.add_product(product, 0)).to be_nil
      expect(cart.add_product(product, -1)).to be_nil
    end
  end

  describe "#mark_as_abandoned" do
    it "marks the cart as abandoned if more than 3 hours have passed" do
      cart = create(:cart, last_interaction_at: 4.hours.ago)
    
      cart.mark_as_abandoned
      cart.reload
    
      expect(cart.abandoned).to be true
    end
  end

  describe "#remove_if_abandoned" do
    it "removes the cart if it has been abandoned for more than 7 days" do
      cart = create(:cart, abandoned: true, last_interaction_at: 8.days.ago)

      cart.remove_if_abandoned
      cart.reload
    
      expect(Cart.exists?(cart.id)).to be false
    end
  end
end