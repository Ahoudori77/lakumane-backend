class CreateItems < ActiveRecord::Migration[7.0]
  def change
    create_table :items do |t|
      t.string :name
      t.text :description
      t.references :category, null: false, foreign_key: true
      t.string :shelf_number
      t.integer :current_quantity
      t.integer :optimal_quantity
      t.integer :reorder_threshold
      t.string :unit
      t.string :manufacturer
      t.text :supplier_info
      t.decimal :price

      t.timestamps
    end
  end
end
