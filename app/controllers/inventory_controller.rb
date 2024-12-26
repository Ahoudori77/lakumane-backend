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

  def show
    item = Item.find_by(id: params[:id])
    if item
      render json: item, status: :ok
    else
      render json: { error: 'Item not found' }, status: :not_found
    end
  end

  def update
    item = Inventory.find_by(id: params[:id])
  
    if item.nil?
      render json: { error: 'Item not found' }, status: :not_found
    elsif item.update(item_params)
      render json: item, status: :ok
    else
      render json: { error: item.errors.full_messages }, status: :unprocessable_entity
    end
  end
  
  def destroy
    item = Inventory.find_by(id: params[:id])
  
    if item.nil?
      render json: { error: 'Item not found' }, status: :not_found
    elsif item.current_quantity > 0
      render json: { error: 'Cannot delete item with stock remaining' }, status: :unprocessable_entity
    else
      item.destroy
      render json: { message: 'Item deleted successfully' }, status: :ok
    end
  end

  private
  
  def item_params
    params.require(:inventory).permit(:name, :current_quantity, :optimal_quantity)
  end
  
end
