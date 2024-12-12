class CreateCategories < ActiveRecord::Migration[7.0]
  def change
    create_table :categories do |t|
      t.string :name, null: false
      t.bigint :parent_id, index: true, foreign_key: { to_table: :categories }
      t.timestamps
    end
  end
end
