class UsageRecord < ApplicationRecord
  belongs_to :item
  belongs_to :user

  validates :usage_date, presence: true
  validates :quantity, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :reason, presence: true
end