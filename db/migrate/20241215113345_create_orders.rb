class CreateOrders < ActiveRecord::Migration[7.0]
  def change
    create_table :orders do |t|
      t.references :item, null: false, foreign_key: true
      t.integer :quantity, null: false
      t.string :status, null: false, default: 'pending'

      t.timestamps
    end
  end
end