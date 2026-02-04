class Cart < ApplicationRecord
  has_many :cart_items, dependent: :destroy
  has_many :products, through: :cart_items
  
  # 添加产品到购物车
  def add_product_to_cart(product)
    # 查找该产品是否已在购物车中
    cart_item = cart_items.find_by(product_id: product.id)
    
    if cart_item
      # 如果已存在，数量 +1
      cart_item.increment!(:quantity)
    else
      # 如果不存在，创建新的 CartItem
      cart_items.create(product: product, quantity: 1)
    end
  end
  
  # 计算购物车总价
  def total_price
    cart_items.includes(:product).sum { |item| item.product.price * item.quantity }
  end
  
  # 获取购物车商品总数量
  def total_quantity
    cart_items.sum(:quantity)
  end
end
