class Order < ApplicationRecord
  belongs_to :item

  validates :quantity, numericality: { greater_than: 0 }
  validates :status, inclusion: { in: %w[pending approved rejected completed] }
  validates :supplier_info, presence: true
end
