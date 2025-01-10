module Api
  module V1
    class InventoryController < ApplicationController
      before_action :authenticate_user!
      rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

      def index
        inventories = Inventory.includes(:item).page(params[:page]).per(params[:per_page])
        render json: { data: inventories.as_json(include: :item) }, status: :ok
      end

      def show
        inventory = Inventory.find(params[:id])
        render json: inventory.as_json(include: :item)
      end
      
      def create
        inventory = Inventory.new(inventory_params)
        if inventory.save
          render json: { data: inventory }, status: :created
        else
          render json: { errors: inventory.errors.messages }, status: :unprocessable_entity
        end
      end

      def update
        inventory = Inventory.find(params[:id])
        if inventory.update(inventory_params)
          render json: { data: inventory }, status: :ok
        else
          render json: { errors: inventory.errors.messages }, status: :unprocessable_entity
        end
      end

      def destroy
        inventory = Inventory.find(params[:id])
        inventory.destroy
        render json: { message: "Inventory deleted successfully" }, status: :ok
      end

      private

      def inventory_params
        params.require(:inventory).permit(:item_id, :current_quantity, :optimal_quantity, :reorder_threshold, :shelf_number, :unit, :unit_price)
      end

      def record_not_found
        render json: { error: "Resource not found" }, status: :not_found
      end
    end
  end
end
