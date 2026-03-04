class FixCartItemsUniqueIndex < ActiveRecord::Migration[8.0]
  def up
    # Remove the old incorrect index if it exists
    if index_name_exists?(:cart_items, "index_cart_items_on_cart_id_and_product_id")
      remove_index :cart_items, name: "index_cart_items_on_cart_id_and_product_id"
    end

    # Add the new correct unique index for product_variant_id within a cart
    unless index_exists?(:cart_items, [:cart_id, :product_variant_id], unique: true)
      add_index :cart_items, [:cart_id, :product_variant_id], unique: true
    end
  end

  def down
    if index_exists?(:cart_items, [:cart_id, :product_variant_id], unique: true)
      remove_index :cart_items, column: [:cart_id, :product_variant_id]
    end
    # We can't easily restore the old broken index because product_id column might not even exist 
    # and it was uniquely on cart_id, which is wrong.
  end
end
