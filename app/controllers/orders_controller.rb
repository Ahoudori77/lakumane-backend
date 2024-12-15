class OrdersController < ApplicationController
  def index
    orders = Order.includes(:item).all
    render json: orders.as_json(include: { item: { only: [:id, :name] } })
  end

  def create
    order = Order.new(order_params)

    if order.save
      render json: order, status: :created
    else
      render json: { errors: order.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def order_params
    params.require(:order).permit(:item_id, :quantity, :status)
  end
end
