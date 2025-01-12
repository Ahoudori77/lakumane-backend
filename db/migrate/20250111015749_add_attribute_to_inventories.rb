class AddAttributeToInventories < ActiveRecord::Migration[7.0]
  def change
    add_column :inventories, :attribute, :string
  end
end
