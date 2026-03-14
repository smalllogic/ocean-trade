class ProductVariant < ApplicationRecord
  belongs_to :product
  has_many :cart_items, dependent: :destroy
  has_many :order_items, dependent: :nullify

  validates :title, presence: true
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :stock, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :sku, uniqueness: { allow_blank: true, message: "has already been taken by another variant" }
  
  validate :sku_uniqueness_in_product
  validate :capacity_or_length_only

  before_validation :nilify_blank_sku

  scope :active, -> { where(is_active: true) }
  scope :ordered, -> { order(position: :asc) }

  private

  def sku_uniqueness_in_product
    return if sku.blank? || !product
    
    # Check if other unsaved or saved variants under the current product have the same SKU
    duplicate_skus = product.variants.select { |v| v != self && v.sku == sku }
    if duplicate_skus.any?
      errors.add(:sku, "is duplicated within this product")
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
