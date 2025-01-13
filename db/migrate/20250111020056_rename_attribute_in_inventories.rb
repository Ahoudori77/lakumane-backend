class RenameAttributeInInventories < ActiveRecord::Migration[7.0]
  def change
    rename_column :inventories, :attribute, :item_attribute
  end
end
