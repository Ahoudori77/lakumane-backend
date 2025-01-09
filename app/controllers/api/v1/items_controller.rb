module Api
  module V1
    class ItemsController < ApplicationController
      before_action :authenticate_user!
      before_action :set_item, only: %i[show update destroy]

      # アイテム一覧
      def index
        items = Item.all
        render json: items.as_json(only: [:id, :name, :unit_price, :current_quantity])
      end

      # アイテム詳細
      def show
        render json: @item
      end

      # アイテム登録
      def create
        item = Item.new(item_params)
        if item.save
          render json: item, status: :created
        else
          render json: { errors: item.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # アイテム更新
      def update
        if @item.update(item_params)
          render json: @item
        else
          render json: { errors: @item.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # アイテム削除
      def destroy
        @item.destroy
        head :no_content
      end

      private

      def set_item
        @item = Item.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: 'Item not found' }, status: :not_found
      end

      def item_params
        params.require(:item).permit(
          :name, :description, :category_id, :shelf_number,
          :current_quantity, :optimal_quantity, :reorder_threshold,
          :unit, :manufacturer, :supplier_info, :price
        )
      end
    end
  end
end
