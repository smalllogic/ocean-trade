class ChangePriceToNullableInProducts < ActiveRecord::Migration[8.0]
  def change
    change_column_null :products, :price, true
  end
end
