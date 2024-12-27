class Item < ApplicationRecord
  belongs_to :category
  has_many :orders
  has_many :notifications

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

  before_save :check_reorder_threshold

  private

  def check_reorder_threshold
    if current_quantity < reorder_threshold
      Notification.create!(
        user_id: User.first.id,  # ユーザーを指定。必要に応じて変更
        item_id: id,
        message: "#{name}の在庫が不足しています（在庫: #{current_quantity}）",
        read: false
      )
    end
  end
end
