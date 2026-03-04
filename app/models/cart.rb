class Cart < ApplicationRecord
  has_many :cart_items, dependent: :destroy
  has_many :product_variants, through: :cart_items
  has_many :products, through: :product_variants
  
  # 添加变体到购物车
  def add_variant_to_cart(variant)
    # 查找该变体是否已在购物车中
    cart_item = cart_items.find_by(product_variant_id: variant.id)
    
    if cart_item
      # 如果已存在，数量 +1
      cart_item.increment!(:quantity)
    else
      # 如果不存在，创建新的 CartItem
      cart_items.create(product_variant: variant, quantity: 1)
    end
  end
  
  # 计算购物车总价
  def total_price
    cart_items.includes(:product_variant).sum { |item| item.product_variant.price * item.quantity }
  end
  
  # 获取购物车商品总数量
  def total_quantity
    cart_items.sum(:quantity)
  end
  
  # 从购物车创建订单
  def build_order(order_params = {})
    # 创建新订单
    order = Order.new(order_params)
    order.status = "pending"
    
    # 遍历购物车项目，创建订单项目
    cart_items.includes(:product_variant).each do |cart_item|
      order.order_items.build(
        product_variant: cart_item.product_variant,
        price: cart_item.product_variant.price,  # 冻结当前价格
        quantity: cart_item.quantity
      )
    end
    
    # 计算订单总价
    order.total_price = order.order_items.sum { |item| item.price * item.quantity }
    
    order
  end
end
