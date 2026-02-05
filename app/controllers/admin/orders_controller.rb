class Admin::OrdersController < Admin::BaseController
  def index
    @orders = Order.order(created_at: :desc)
  end
  
  def show
    @order = Order.find(params[:id])
  end
  
  def update_status
    @order = Order.find(params[:id])
    
    if @order.update(status: params[:status])
      redirect_to admin_order_path(@order), notice: "Order status updated to: #{status_text(@order.status)}"
    else
      redirect_to admin_order_path(@order), alert: "Update failed"
    end
  end
  
  private
  
  def status_text(status)
    {
      'pending' => 'Pending Payment',
      'paid' => 'Paid',
      'shipped' => 'Shipped',
      'completed' => 'Completed'
    }[status]
  end
end
