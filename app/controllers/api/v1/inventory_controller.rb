module Api
  module V1
    class InventoryController < ApplicationController
      before_action :authenticate_user!

      def index
        inventory_items = Item.all
        render json: inventory_items
      end

      def update
        item = Item.find(params[:id])
        new_quantity = item.current_quantity + params[:quantity].to_i

        if new_quantity < 0
          render json: { error: "Quantity cannot be negative" }, status: :unprocessable_entity
        else
          item.update!(current_quantity: new_quantity)
          render json: item, status: :ok
        end
      rescue ActiveRecord::RecordNotFound
        render json: { error: "Item not found" }, status: :not_found
      end
    end
  end
end
