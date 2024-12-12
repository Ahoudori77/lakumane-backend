class CreateItems < ActiveRecord::Migration[7.0]
  def change
    create_table :items do |t|
      t.string :name, null: false
      t.text :description
      t.references :category, foreign_key: true
      t.string :shelf_number, unique: true
      t.integer :current_quantity, null: false
      t.integer :optimal_quantity, null: false
      t.integer :reorder_threshold, null: false
      t.string :unit
      t.string :manufacturer
      t.text :supplier_info
      t.decimal :price, precision: 10, scale: 2
      t.datetime :created_at, null: false
      t.datetime :updated_at, null: false
    end
  end
end
