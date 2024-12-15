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
  
  def create
    item = Item.new(item_params)
    if item.save
      render json: item, status: :created
    else
      render json: { errors: item.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    item = Item.find(params[:id])
    if item.update(item_params)
      render json: item, status: :ok
    else
      render json: { errors: item.errors.full_messages }, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Item not found' }, status: :not_found
  end
  

  def destroy
    item = Item.find(params[:id])
    item.destroy
    head :no_content
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Item not found' }, status: :not_found
  end

  private

  def item_params
    params.require(:item).permit(:name, :description, :category_id, :shelf_number, :current_quantity, :optimal_quantity, :reorder_threshold, :unit, :manufacturer, :supplier_info, :price)
  end
end
