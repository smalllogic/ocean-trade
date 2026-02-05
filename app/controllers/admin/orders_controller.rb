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
      redirect_to admin_order_path(@order), notice: "订单状态已更新为：#{status_text(@order.status)}"
    else
      redirect_to admin_order_path(@order), alert: "更新失败"
    end
  end
  
  private
  
  def status_text(status)
    {
      'pending' => '待支付',
      'paid' => '已支付',
      'shipped' => '已发货',
      'completed' => '已完成'
    }[status]
  end
end
