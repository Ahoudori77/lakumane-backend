class AddCategoryToNotifications < ActiveRecord::Migration[6.1]
  def change
    add_column :notifications, :category, :string, null: false, default: "unclassified"
  end
end