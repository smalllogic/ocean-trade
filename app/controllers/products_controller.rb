class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :add_to_cart]
  before_action :check_product_visibility, only: [:show]
  
  def index
    @products = Product.visible.ordered_by_newest
  end
  
  def show
  end
  
  def add_to_cart
    current_cart.add_product_to_cart(@product)
    redirect_to product_path(@product), notice: "#{@product.name} has been added to cart"
  end
  
  private
  
  def set_product
    @product = Product.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to products_path, alert: "产品不存在"
  end
  
  def check_product_visibility
    if @product.hidden?
      redirect_to products_path, alert: "该产品暂时无法查看"
    end
  end
end
