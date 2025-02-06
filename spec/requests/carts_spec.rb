require 'rails_helper'

RSpec.describe "/carts", type: :request do
  let(:cart) { create(:cart) }
  let(:product) { create(:product, name: "Test Product", price: 10.0) }
  let!(:cart_item) { create(:cart_item, cart: cart, product: product, quantity: 1) }

  before do
    allow_any_instance_of(ApplicationController).to receive(:session).and_return({ cart_id: cart.id })
  end

  describe "POST /cart/add_item" do
    context "when adding a new product to the cart" do
      xit "creates a new cart item" do
        expect {
          post "/cart/add_item", params: { product_id: product.id, quantity: 2 }, as: :json
        }.to change { cart.cart_items.count }.by(1)

        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response["products"].size).to eq(2)
        expect(json_response["products"].last["quantity"]).to eq(2)
      end
    end

    context "when the product is already in the cart" do
      subject do
        post "/cart/add_item", params: { product_id: product.id, quantity: 1 }, as: :json
        post "/cart/add_item", params: { product_id: product.id, quantity: 1 }, as: :json
      end

      xit "updates the quantity of the existing item in the cart" do
        expect { subject }.to change { cart_item.reload.quantity }.by(2)
      end
    end

    context "when quantity is invalid" do
      xit "returns an error" do
        post "/cart/add_item", params: { product_id: product.id, quantity: 0 }, as: :json

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)["error"]).to eq("Quantidade inválida")
      end
    end
  end

  describe "GET /cart" do
    xit "returns the cart with products" do
      get "/cart", as: :json

      expect(response).to have_http_status(:ok)
      json_response = JSON.parse(response.body)
      expect(json_response["products"].size).to eq(1)
      expect(json_response["products"][0]["id"]).to eq(product.id)
      expect(json_response["products"][0]["quantity"]).to eq(1)
    end
  end

  describe "DELETE /cart/remove_product" do
    xit "removes a product from the cart" do
      expect {
        delete "/cart/remove_product", params: { product_id: product.id }, as: :json
      }.to change { cart.cart_items.count }.by(-1)

      expect(response).to have_http_status(:ok)
    end

    xit "returns an error if the product is not in the cart" do
      delete "/cart/remove_product", params: { product_id: 999 }, as: :json

      expect(response).to have_http_status(:not_found)
      expect(JSON.parse(response.body)["error"]).to eq("Produto não encontrado")
    end

    xit "deletes the cart if it becomes empty" do
      delete "/cart/remove_product", params: { product_id: product.id }, as: :json

      expect(response).to have_http_status(:ok)
      expect(Cart.exists?(cart.id)).to be false
    end
  end
end