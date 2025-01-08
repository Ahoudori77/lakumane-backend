module Api
  module V1
    class UsageRecordsController < ApplicationController
      before_action :authenticate_user!

      def index
        @usage_records = UsageRecord.all
        render json: @usage_records
      end

      def create
        item = Item.find(params[:item_id])
        quantity = params[:quantity].to_i

        if quantity <= 0
          render json: { error: 'Quantity must be a positive number' }, status: :unprocessable_entity
          return
        end

        new_quantity = item.current_quantity - quantity
        if new_quantity < 0
          render json: { error: 'Not enough inventory' }, status: :unprocessable_entity
          return
        end

        UsageRecord.create!(
          item: item,
          user: current_user,
          quantity: quantity
        )
        item.update!(current_quantity: new_quantity)

        render json: { message: 'Usage recorded successfully', item: item }, status: :ok
      rescue ActiveRecord::RecordNotFound
        render json: { error: 'Item not found' }, status: :not_found
      rescue ActiveRecord::RecordInvalid => e
        render json: { error: e.message }, status: :unprocessable_entity
      end
    end
  end
end
