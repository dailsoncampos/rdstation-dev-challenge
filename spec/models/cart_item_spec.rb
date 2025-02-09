require 'rails_helper'

RSpec.describe CartItem, type: :model do
  let(:cart_item) { create(:cart_item) }

  describe "validations" do
    it "is valid with a positive quantity" do
      expect(cart_item).to be_valid
    end

    it "is invalid with a negative or zero quantity" do
      cart_item.quantity = 0
      expect(cart_item).to_not be_valid

      cart_item.quantity = -2
      expect(cart_item).to_not be_valid
    end
  end

  describe "#total_price" do
    it "correctly calculates the total price of the item" do
      product = create(:product, price: 15.0)
      cart_item = create(:cart_item, product: product, quantity: 3)
      expect(cart_item.total_price).to eq(45.0)
    end
  end
end
