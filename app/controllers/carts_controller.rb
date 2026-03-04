class CartsController < ApplicationController
  before_action :set_cart
  before_action :set_cart_item, only: [:increase_quantity, :decrease_quantity, :remove_item]

  def show
    @cart_items = @cart.cart_items.includes(product_variant: :product)
  end

  def add_item
    product = Product.find(params[:product_id])
    # 如果有变体 ID，则添加特定变体，否则添加默认变体
    variant = params[:variant_id] ? product.variants.find(params[:variant_id]) : product.default_variant
    
    if variant
      @cart.add_variant_to_cart(variant)
      redirect_to cart_path, notice: "#{product.name} has been added to cart"
    else
      redirect_to product_path(product), alert: "Please select a variant"
    end
  end

  # 增加数量
  def increase_quantity
    @cart_item.update(quantity: @cart_item.quantity + 1)
    redirect_to cart_path, notice: 'Quantity increased'
  end

  # 减少数量
  def decrease_quantity
    if @cart_item.quantity > 1
      @cart_item.update(quantity: @cart_item.quantity - 1)
      redirect_to cart_path, notice: 'Quantity decreased'
    else
      @cart_item.destroy
      redirect_to cart_path, notice: 'Item removed from cart'
    end
  end

  # 删除商品
  def remove_item
    @cart_item.destroy
    redirect_to cart_path, notice: 'Item removed from cart'
  end

  private

  def set_cart
    @cart = current_cart
  end

  def set_cart_item
    @cart_item = @cart.cart_items.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to cart_path, alert: 'Item not found'
  end
end
