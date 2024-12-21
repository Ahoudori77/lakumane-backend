class Item < ApplicationRecord
  belongs_to :category

  validates :name, presence: true
  validates :description, presence: true
  validates :category_id, presence: true
  validates :shelf_number, presence: true
  validates :current_quantity, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :optimal_quantity, numericality: { only_integer: true, greater_than: 0 }
  validates :reorder_threshold, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :unit, presence: true
  validates :manufacturer, presence: true
  validates :supplier_info, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0 }
end
