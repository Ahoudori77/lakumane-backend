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
        quantity = params[:quantity]

        # バリデーション: quantityが数値であるか
        unless quantity.present? && quantity.to_s.match?(/\A-?\d+\z/)
          render json: { error: { message: 'Quantity must be a number' } }, status: :unprocessable_entity
          return
        end

        quantity = quantity.to_i
        new_quantity = item.current_quantity + quantity

        # 在庫数が負になる場合のエラー
        if new_quantity < 0
          render json: { error: { message: 'Quantity cannot be negative' } }, status: :unprocessable_entity
          return
        end

        # 在庫を更新
        item.update!(current_quantity: new_quantity)

        # reorder_thresholdを下回る場合の警告
        warning = new_quantity < item.reorder_threshold ? "Inventory is below reorder threshold" : nil

        render json: item.as_json.merge(warning: warning), status: :ok
      rescue ActiveRecord::RecordNotFound
        render json: { error: { message: 'Item not found' } }, status: :not_found
      end
    end
  end
end
