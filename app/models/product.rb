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
  validates :description, length: { maximum: 5000 }
  
  # 业务约束 1: product 挂载最底层分类（叶子分类）
  validate :category_must_be_leaf
  
  # 验证：必须有活动的变体
  validate :at_least_one_active_variant
  # 验证：变体的错误也冒泡到 product 上
  validate :variants_must_be_valid

  # 作用域
  scope :visible, -> { where(is_hidden: false) }
  scope :hidden, -> { where(is_hidden: true) }
  scope :ordered_by_newest, -> { order(created_at: :desc) }
  scope :by_position, -> { order(sort_order: :asc, created_at: :desc) }
  
  # 方法
  def default_variant
    variants.active.ordered.first
  end

  def min_price
    variants.active.minimum(:price) || 0
  end

  def max_price
    variants.active.maximum(:price) || 0
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
      errors.add(:category_id, "must be a leaf category (cannot select a category that contains subcategories)")
    end
  end

  def at_least_one_active_variant
    active_variants = variants.reject(&:marked_for_destruction?).select { |v| v.is_active? }
    if active_variants.empty?
      errors.add(:base, "must have at least one active product variant")
    end
  end

  def variants_must_be_valid
    variants.each do |variant|
      if variant.invalid?
        variant.errors.full_messages.each do |msg|
          errors.add(:base, "Variant error: #{msg}")
        end
      end
    end
  end
end
