class Order < ApplicationRecord
  has_many :order_items, dependent: :destroy
  has_many :products, through: :order_items
  
  # 验证
  validates :total_price, presence: true, numericality: { greater_than: 0 }
  validates :status, presence: true, inclusion: { in: %w[pending paid shipped completed] }
  validates :name, presence: true
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :phone, presence: true
  validates :address, presence: true
  
  # 状态机
  def pending?
    status == "pending"
  end
  
  def paid?
    status == "paid"
  end
  
  def shipped?
    status == "shipped"
  end
  
  def completed?
    status == "completed"
  end
end
