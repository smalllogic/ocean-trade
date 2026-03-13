class ProductVariant < ApplicationRecord
  belongs_to :product
  has_many :cart_items, dependent: :destroy
  has_many :order_items, dependent: :nullify

  validates :title, presence: true
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :stock, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :sku, uniqueness: { allow_blank: true, message: "已经被其他规格占用了" }
  
  validate :sku_uniqueness_in_product
  validate :capacity_or_length_only

  before_validation :nilify_blank_sku

  scope :active, -> { where(is_active: true) }
  scope :ordered, -> { order(position: :asc) }

  private

  def sku_uniqueness_in_product
    return if sku.blank? || !product
    
    # 检查当前产品下其他未保存或已保存的规格是否有相同 SKU
    duplicate_skus = product.variants.select { |v| v != self && v.sku == sku }
    if duplicate_skus.any?
      errors.add(:sku, "在该产品内重复")
    end
  end

  def capacity_or_length_only
    if capacity.present? && length.present?
      errors.add(:base, "Capacity and length cannot both be filled. Please choose only one.")
    end
  end

  def nilify_blank_sku
    self.sku = nil if sku.blank?
  end
end
