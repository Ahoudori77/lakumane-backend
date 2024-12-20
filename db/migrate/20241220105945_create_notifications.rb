class CreateNotifications < ActiveRecord::Migration[7.0]
  def change
    create_table :notifications do |t|
      t.string :message
      t.references :user, null: false, foreign_key: true
      t.references :item, null: false, foreign_key: true
      t.boolean :read

      t.timestamps
    end
  end
end
