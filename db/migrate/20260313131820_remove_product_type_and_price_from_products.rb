class RemoveProductTypeAndPriceFromProducts < ActiveRecord::Migration[8.0]
  def change
    remove_column :products, :product_type, :string
    remove_column :products, :price, :decimal
  end
end
