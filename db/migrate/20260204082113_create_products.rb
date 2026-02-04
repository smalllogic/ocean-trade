class CreateProducts < ActiveRecord::Migration[8.0]
  def change
    create_table :products do |t|
      t.string :name, null: false
      t.decimal :price, precision: 10, scale: 2, null: false
      t.text :description
      t.boolean :is_hidden, default: false, null: false

      t.timestamps
    end
    
    add_index :products, :is_hidden
  end
end
