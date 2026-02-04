class Product < ApplicationRecord
  # Active Storage 图片关联
  has_one_attached :image
  
  # 验证
  validates :name, presence: true, length: { maximum: 255 }
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :description, length: { maximum: 5000 }
  
  # 作用域
  scope :visible, -> { where(is_hidden: false) }
  scope :hidden, -> { where(is_hidden: true) }
  scope :ordered_by_newest, -> { order(created_at: :desc) }
  
  # 方法
  def hidden?
    is_hidden
  end
  
  def visible?
    !is_hidden
  end
end
