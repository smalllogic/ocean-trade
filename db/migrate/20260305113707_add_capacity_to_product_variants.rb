class AddCapacityToProductVariants < ActiveRecord::Migration[8.0]
  def change
    add_column :product_variants, :capacity, :string
  end
end
