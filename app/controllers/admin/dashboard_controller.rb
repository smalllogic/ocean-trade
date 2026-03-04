class Admin::DashboardController < Admin::BaseController
  def index
    @orders = Order.order(created_at: :desc)
    @products_count = Product.count
    @orders_count = Order.count
    @pending_orders_count = Order.where(status: 'pending').count
    @total_sales = Order.where(status: ['paid', 'shipped', 'completed']).sum(:total_price)
  end
end
