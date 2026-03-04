class AddSummaryAndProductTypeToProducts < ActiveRecord::Migration[8.0]
  def change
    add_column :products, :summary, :text
    add_column :products, :product_type, :string
    add_column :products, :sort_order, :integer
  end
end
