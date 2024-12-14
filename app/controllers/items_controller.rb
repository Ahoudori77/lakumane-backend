class ItemsController < ApplicationController
  def index
    items = Item.includes(:category).all
    render json: items.as_json(include: { category: { only: :name } })
  end
  def show
    item = Item.includes(:category).find(params[:id])
    render json: {
      id: item.id,
      name: item.name,
      description: item.description,
      category: item.category.name,
      shelf_number: item.shelf_number,
      current_quantity: item.current_quantity,
      optimal_quantity: item.optimal_quantity,
      reorder_threshold: item.reorder_threshold,
      unit: item.unit,
      manufacturer: item.manufacturer,
      supplier_info: item.supplier_info,
      price: item.price
    }
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Item not found' }, status: :not_found
  end
end
