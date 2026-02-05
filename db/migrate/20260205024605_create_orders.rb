class CreateOrders < ActiveRecord::Migration[8.0]
  def change
    create_table :orders do |t|
      t.decimal :total_price, precision: 10, scale: 2, null: false
      t.string :status, null: false, default: "pending"
      t.string :name, null: false
      t.string :email, null: false
      t.string :phone, null: false
      t.text :address, null: false

      t.timestamps
    end
    
    add_index :orders, :status
    add_index :orders, :email
  end
end
