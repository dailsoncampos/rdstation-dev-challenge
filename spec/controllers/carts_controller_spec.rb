require 'rails_helper'

RSpec.describe CartsController, type: :controller do
  let(:cart) { create(:cart) }
  let(:product) { create(:product) }

  before do
    session[:cart_id] = cart.id
  end

  describe "POST #add_product" do
    context "with valid quantity" do
      it "adds the product to the cart" do
        expect {
          post :add_product, params: { product_id: product.id, quantity: 2 }
        }.to change { cart.cart_items.count }.by(1)

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)["products"].size).to eq(1)
        expect(JSON.parse(response.body)["products"][0]["id"]).to eq(product.id)
        expect(JSON.parse(response.body)["products"][0]["quantity"]).to eq(2)
      end

      it "updates the quantity if the product is already in the cart" do
        create(:cart_item, cart: cart, product: product, quantity: 1)

        post :add_product, params: { product_id: product.id, quantity: 2 }

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)["products"][0]["quantity"]).to eq(3)
      end
    end

    context "with invalid quantity" do
      it "returns invalid quantity error" do
        post :add_product, params: { product_id: product.id, quantity: 0 }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)["error"]).to eq("Quantidade inválida")
      end
    end
  end

  describe "GET #show" do
    it "returns the cart products" do
      create(:cart_item, cart: cart, product: product, quantity: 1)

      get :show

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)["products"].size).to eq(1)
      expect(JSON.parse(response.body)["products"][0]["id"]).to eq(product.id)
      expect(JSON.parse(response.body)["products"][0]["quantity"]).to eq(1)
    end
  end

  describe "DELETE #remove_product" do
    it "removes the product from the cart" do
      cart_item = create(:cart_item, cart: cart, product: product, quantity: 1)

      delete :remove_product, params: { product_id: product.id }

      expect(response).to have_http_status(:ok)
      expect(cart.cart_items.count).to eq(0)
    end

    it "returns error if the product is not in the cart" do
      delete :remove_product, params: { product_id: product.id }

      expect(response).to have_http_status(:not_found)
      expect(JSON.parse(response.body)["error"]).to eq("Produto não encontrado")
    end

    it "destroys the cart if it becomes empty" do
      cart_item = create(:cart_item, cart: cart, product: product, quantity: 1)

      delete :remove_product, params: { product_id: product.id }

      expect(Cart.exists?(cart.id)).to be false
    end
  end
end