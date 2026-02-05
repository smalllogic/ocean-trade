class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :product
  
  # 验证
  validates :price, presence: true, numericality: { greater_than: 0 }
  validates :quantity, presence: true, numericality: { greater_than: 0 }
  
  # 小计
  def subtotal
    price * quantity
  end
end
