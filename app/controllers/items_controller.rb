class ItemsController < ApplicationController
  def index
    items = Item.includes(:category).all
    render json: items.as_json(include: { category: { only: :name } })
  end
end
