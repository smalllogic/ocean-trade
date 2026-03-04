class CreateProductVariants < ActiveRecord::Migration[8.0]
  def change
    create_table :product_variants do |t|
      t.references :product, null: false, foreign_key: true
      t.string :title, null: false
      t.decimal :price, precision: 10, scale: 2, null: false, default: 0
      t.integer :stock, default: 0
      t.boolean :is_active, default: true
      t.string :sku
      t.integer :position, default: 0
      t.integer :length

      t.timestamps
    end
    add_index :product_variants, :sku, unique: true
  end
end
