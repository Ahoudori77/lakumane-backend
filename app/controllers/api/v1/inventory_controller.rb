module Api
  module V1
    class InventoryController < ApplicationController
      before_action :authenticate_user!

      def index
        inventories = Inventory.includes(:item).all
        render json: inventories.as_json(include: :item)
      end

      def update
        inventory = Inventory.find(params[:id])
        if inventory.update(inventory_params)
          render json: inventory
        else
          render json: { errors: inventory.errors.full_messages }, status: :unprocessable_entity
        end
      rescue ActiveRecord::RecordNotFound
        render json: { error: "Inventory not found" }, status: :not_found
      end

      def show
        inventory = Inventory.find(params[:id])
        render json: inventory.as_json(include: :item)
      rescue ActiveRecord::RecordNotFound
        render json: { error: "Inventory not found" }, status: :not_found
      end

      def create
        inventory = Inventory.new(inventory_params)
        if inventory.save
          render json: inventory, status: :created
        else
          render json: { errors: inventory.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        inventory = Inventory.find(params[:id])
        inventory.destroy
        render json: { message: "Inventory deleted successfully" }, status: :ok
      rescue ActiveRecord::RecordNotFound
        render json: { error: "Inventory not found" }, status: :not_found
      end

      private

      def inventory_params
        params.require(:inventory).permit(:item_id, :current_quantity, :optimal_quantity, :reorder_threshold, :shelf_number, :unit, :unit_price)
      end     
    end
  end
end
