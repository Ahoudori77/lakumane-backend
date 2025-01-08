class ChangeDefaultForCategoryInNotifications < ActiveRecord::Migration[6.1]
  def change
    change_column_default :notifications, :category, from: "info", to: "unclassified"
  end
end
