class AddSupplierInfoToOrders < ActiveRecord::Migration[7.0]
  def change
    add_column :orders, :supplier_info, :string
  end
end
