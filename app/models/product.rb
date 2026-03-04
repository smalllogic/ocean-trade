class Product < ApplicationRecord
  # Active Storage 图片关联
  has_many_attached :images
  
  # 关联
  belongs_to :category, optional: true
  has_many :variants, class_name: "ProductVariant", dependent: :destroy
  
  # 允许嵌套属性，方便后台一次性保存变体
  accepts_nested_attributes_for :variants, allow_destroy: true, reject_if: :all_blank

  # 验证
  validates :name, presence: true, length: { maximum: 255 }
  # 移除 price 必填验证，或者保留并允许为 nil
  validates :price, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :description, length: { maximum: 5000 }
  validates :product_type, inclusion: { in: %w(hair care), allow_blank: true }
  
  # 业务约束 1: product 只能挂最底层分类（叶子分类）
  validate :category_must_be_leaf
  
  # 作用域
  scope :visible, -> { where(is_hidden: false) }
  scope :hidden, -> { where(is_hidden: true) }
  scope :ordered_by_newest, -> { order(created_at: :desc) }
  scope :by_position, -> { order(sort_order: :asc, created_at: :desc) }
  
  # 方法
  def default_variant
    variants.ordered.first
  end

  def min_price
    variants.active.minimum(:price) || price
  end

  def max_price
    variants.active.maximum(:price) || price
  end
  def hidden?
    is_hidden
  end
  
  def visible?
    !is_hidden
  end

  private

  def category_must_be_leaf
    if category.present? && !category.leaf?
      errors.add(:category_id, "必须是底层（叶子）分类，不能挂在有子分类的节点下")
    end
  end
end
