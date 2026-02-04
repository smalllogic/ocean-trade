class CartItem < ApplicationRecord
  belongs_to :cart
  belongs_to :product
  
  validates :quantity, presence: true, numericality: { greater_than: 0 }
  validates :product_id, uniqueness: { scope: :cart_id, message: "已在购物车中" }
  
  # 小计（单个 CartItem 的总价）
  def subtotal
    product.price * quantity
  end
end
