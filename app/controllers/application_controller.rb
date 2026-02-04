class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  
  helper_method :current_cart
  
  private
  
  def current_cart
    if session[:cart_id]
      @current_cart ||= Cart.find_by(id: session[:cart_id])
    end
    
    if @current_cart.nil?
      @current_cart = Cart.create
      session[:cart_id] = @current_cart.id
    end
    
    @current_cart
  end
end
