class CreateUsageRecords < ActiveRecord::Migration[7.0]
  def change
    create_table :usage_records do |t|
      t.references :item, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.datetime :usage_date
      t.integer :quantity
      t.string :reason

      t.timestamps
    end
  end
end
