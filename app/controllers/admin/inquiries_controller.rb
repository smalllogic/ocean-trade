class Admin::InquiriesController < Admin::BaseController
  before_action :set_inquiry, only: [:show, :mark_as_read, :destroy]

  def index
    @inquiries = Inquiry.ordered
  end

  def show
    @inquiry.update(status: 'read') if @inquiry.unread?
  end

  def mark_as_read
    @inquiry.update(status: 'read')
    redirect_to admin_inquiries_path, notice: "Message marked as read"
  end

  def destroy
    @inquiry.destroy
    redirect_to admin_inquiries_path, notice: "Message deleted"
  end

  private

  def set_inquiry
    @inquiry = Inquiry.find(params[:id])
  end
end
