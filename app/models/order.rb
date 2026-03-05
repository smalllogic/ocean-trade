class Order < ApplicationRecord
  # Associations
  has_many :order_items, dependent: :destroy
  has_many :products, through: :order_items
  
  # Validations
  validates :total_price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :status, presence: true, inclusion: { in: %w[pending paid shipped completed] }
  validates :name, presence: true
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :phone, presence: true
  validates :address, presence: true
  
  # Status state machine methods
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
