class Admin::BaseController < ApplicationController
  layout 'admin'
  before_action :authenticate_user!
  before_action :verify_admin
  
  private
  
  def verify_admin
    unless current_user.admin?
      redirect_to root_path, alert: "您没有权限访问此页面"
    end
  end
end
