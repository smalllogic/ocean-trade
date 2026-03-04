class ProductVariant < ApplicationRecord
  belongs_to :product

  validates :title, presence: true
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :stock, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :sku, uniqueness: { allow_blank: true }
  
  before_validation :nilify_blank_sku

  scope :active, -> { where(is_active: true) }
  scope :ordered, -> { order(position: :asc) }

  private

  def nilify_blank_sku
    self.sku = nil if sku.blank?
  end
end
