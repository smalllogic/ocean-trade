class Cart < ApplicationRecord
  has_many :cart_items, dependent: :destroy
  has_many :product_variants, through: :cart_items
  has_many :products, through: :product_variants
  
  # Add variant to cart
  def add_variant_to_cart(variant)
    # Check if this variant is already in the cart
    cart_item = cart_items.find_by(product_variant_id: variant.id)
    
    if cart_item
      # If exists, increment quantity
      cart_item.increment!(:quantity)
    else
      # If not exists, create new CartItem
      cart_items.create(product_variant: variant, quantity: 1)
    end
  end
  
  # Calculate cart total price
  def total_price
    cart_items.includes(:product_variant).sum { |item| item.product_variant.price * item.quantity }
  end
  
  # Get total quantity of items in cart
  def total_quantity
    cart_items.sum(:quantity)
  end
  
  # Build order from cart
  def build_order(order_params = {})
    # Create new order
    order = Order.new(order_params)
    order.status = "pending"
    
    # Iterate through cart items and build order items
    cart_items.includes(:product_variant).each do |cart_item|
      order.order_items.build(
        product_variant: cart_item.product_variant,
        price: cart_item.product_variant.price,  # Freeze current price
        quantity: cart_item.quantity
      )
    end
    
    # Calculate order total price
    order.total_price = order.order_items.sum { |item| item.price * item.quantity }
    
    order
  end
end
