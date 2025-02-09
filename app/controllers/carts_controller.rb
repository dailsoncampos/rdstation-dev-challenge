class CartsController < ApplicationController
  before_action :set_cart, only: [:add_product, :show, :update_item, :remove_product]

  def add_product
    product = Product.find_by(id: params[:product_id])
    return render json: { error: "Produto não encontrado" }, status: :not_found unless product

    quantity = params[:quantity].to_i
    return render json: { error: "Quantidade inválida" }, status: :unprocessable_entity if quantity <= 0

    cart_item = @cart.add_product(product, quantity)

    render json: cart_response, status: :ok
  end

  def show
    render json: cart_response
  end

  def update_item
    cart_item = @cart.cart_items.find_by(product_id: params[:product_id])
    return render json: { error: "Produto não encontrado" }, status: :not_found unless cart_item

    quantity = params[:quantity].to_i
    return render json: { error: "Quantidade inválida" }, status: :unprocessable_entity if quantity <= 0

    cart_item.update!(quantity: quantity)

    render json: cart_response, status: :ok
  end

  def remove_product
    cart_item = @cart.cart_items.find_by(product_id: params[:product_id])
    return render json: { error: "Produto não encontrado" }, status: :not_found unless cart_item

    cart_item.destroy
    @cart.destroy if @cart.cart_items.empty?

    render json: cart_response, status: :ok
  end

  private

  def set_cart
    @cart = Cart.find_by(id: session[:cart_id]) || Cart.create
    session[:cart_id] = @cart.id unless session[:cart_id]
  end  

  def cart_response
    {
      id: @cart.id,
      products: @cart.cart_items.map do |item|
        {
          id: item.product.id,
          name: item.product.name,
          quantity: item.quantity,
          unit_price: item.product.price,
          total_price: item.total_price
        }
      end,
      total_price: @cart.total_price
    }
  end
end
