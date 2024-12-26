require 'csv'

module Api
  module V1
    class OrdersController < ApplicationController
      before_action :authenticate_user!
      before_action :set_order, only: [:show, :update, :destroy]

      def index
        @orders = Order.includes(:item).all
        render json: @orders, include: [:item]
      end

      def show
        render json: @order, include: :item
      end

      def update
        if @order.update(order_params)
          render json: @order
        else
          render json: @order.errors, status: :unprocessable_entity
        end
      end

      def destroy
        @order.destroy
        head :no_content  # 削除後は204 No Contentを返す
      end

      def export_csv
        @orders = Order.includes(:item).all
      
        csv_data = CSV.generate(encoding: 'Shift_JIS') do |csv|
          csv << ['ID', '商品名', '数量', 'ステータス', 'サプライヤー情報']
          @orders.each do |order|
            csv << [
              order.id,
              order.item.name,
              order.quantity,
              order.status,
              order.supplier_info
            ]
          end
        end
      
        send_data csv_data, filename: "orders_#{Time.zone.now.strftime('%Y%m%d')}.csv"
      end
      

      def import_csv
        csv_file = params[:file]
        
        if csv_file.present?
          CSV.foreach(csv_file.path, headers: true) do |row|
            item = Item.find_by(name: row['Item Name'])
            next unless item
      
            Order.create!(
              item: item,
              quantity: row['Quantity'],
              status: row['Status'],
              supplier_info: row['Supplier Info']
            )
          end
          render json: { message: 'CSVのインポートが完了しました' }, status: :ok
        else
          render json: { error: 'CSVファイルが指定されていません' }, status: :unprocessable_entity
        end
      end

      private

      def set_order
        @order = Order.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: "Order not found" }, status: :not_found
      end

      def order_params
        params.require(:order).permit(:item_id, :quantity, :status, :supplier_info)
      end
    end
  end
end
