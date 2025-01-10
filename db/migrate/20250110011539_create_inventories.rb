class CreateInventories < ActiveRecord::Migration[7.0]
  def change
    create_table :inventories do |t|
      t.references :item, null: false, foreign_key: true
      t.integer :current_quantity, null: false, default: 0
      t.integer :optimal_quantity, null: false, default: 0
      t.integer :reorder_threshold, null: false, default: 0
      t.string :shelf_number, null: false
      t.string :unit, null: false
      t.decimal :unit_price, precision: 10, scale: 2, null: true
      t.datetime :last_updated_at, null: true
      t.timestamps
    end
  end
end
