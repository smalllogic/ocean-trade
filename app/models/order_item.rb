class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :product_variant
  
  has_one :product, through: :product_variant
  
  # 验证
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :quantity, presence: true, numericality: { greater_than: 0 }
  
  # 小计
  def subtotal
    price * quantity
  end
end
