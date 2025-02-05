require "rails_helper"

RSpec.describe CartsController, type: :routing do
  describe 'routes' do
    it 'routes to #show' do
      expect(get: '/cart').to route_to('carts#show')
    end

    it 'routes to #add_product via POST' do
      expect(post: '/cart/add_item').to route_to('carts#add_product')
    end

    it 'routes to #update_item via PATCH' do
      expect(patch: '/cart/update_item').to route_to('carts#update_item')
    end

    it 'routes to #remove_product via DELETE' do
      expect(delete: '/cart/remove_product/1').to route_to('carts#remove_product', product_id: '1')
    end
  end
end