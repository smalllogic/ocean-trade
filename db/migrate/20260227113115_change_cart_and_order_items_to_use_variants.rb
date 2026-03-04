class ChangeCartAndOrderItemsToUseVariants < ActiveRecord::Migration[8.0]
  def change
    # 清空现有购物车和订单项，因为结构发生了重大变化且旧数据无法直接映射到 Variant（不知道该对应哪个 Variant）
    CartItem.delete_all
    OrderItem.delete_all

    # CartItems
    remove_reference :cart_items, :product, index: true, foreign_key: true
    add_reference :cart_items, :product_variant, index: true, foreign_key: true

    # OrderItems
    remove_reference :order_items, :product, index: true, foreign_key: true
    add_reference :order_items, :product_variant, index: true, foreign_key: true
  end
end
