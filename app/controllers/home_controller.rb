class HomeController < ApplicationController
  def index
  end

  def refund_policy
  end

  def help_center
  end

  def contact_us
    @inquiry = Inquiry.new
  end

  def create_inquiry
    @inquiry = Inquiry.new(inquiry_params)
    if @inquiry.save
      redirect_to contact_us_path, notice: "Thank you for your message! Our concierge team will review it and get back to you shortly."
    else
      render :contact_us, status: :unprocessable_entity
    end
  end

  private

  def inquiry_params
    params.require(:inquiry).permit(:name, :email, :subject, :message)
  end
end
