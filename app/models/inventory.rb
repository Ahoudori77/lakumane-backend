class Inventory < ApplicationRecord
  belongs_to :item

  validates :current_quantity, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :optimal_quantity, numericality: { only_integer: true, greater_than: 0 }
  validates :reorder_threshold, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :unit, presence: true
  validates :shelf_number, presence: true

  before_save :update_last_updated_at

  private

  def update_last_updated_at
    self.last_updated_at = Time.current
  end
end
