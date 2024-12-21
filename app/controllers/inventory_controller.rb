class InventoryController < ApplicationController
  before_action :authenticate_user!


  def index
    inventory = Item.select(:id, :name, :current_quantity, :optimal_quantity, :reorder_threshold)
    render json: inventory, status: :ok
  end

  def update
    item = Item.find(params[:id])
    new_quantity = item.current_quantity + params[:quantity].to_i

    if new_quantity >= 0
      item.update(current_quantity: new_quantity)
      render json: item, status: :ok
    else
      render json: { error: 'Quantity cannot be negative' }, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Item not found' }, status: :not_found
  end
end
