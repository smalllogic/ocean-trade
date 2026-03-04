class Category < ApplicationRecord
  has_many :children, class_name: "Category", foreign_key: "parent_id", dependent: :destroy
  belongs_to :parent, class_name: "Category", optional: true
  has_many :products

  validates :name, presence: true

  # Business constraint 2: A category's parent cannot have children if it already has products
  validate :no_children_if_has_products
  # Business constraint (extended): If a category has children, it cannot have products directly
  validate :no_products_if_has_children

  def leaf?
    children.empty?
  end

  # 取从根到当前节点的路径（含自身）
  def path_from_root
    node = self
    path = []
    while node
      path << node
      node = node.parent
    end
    path.reverse
  end

  # 所有后代节点
  def descendants
    result = []
    queue = children.to_a.dup
    until queue.empty?
      c = queue.shift
      result << c
      queue.concat(c.children) if c.children.any?
    end
    result
  end

  # 所有叶子后代
  def leaf_descendants
    (descendants.presence || []).select(&:leaf?)
  end

  # 自身及所有后代 id
  def self_and_descendant_ids
    [id] + descendants.map(&:id)
  end

  private

  def no_children_if_has_products
    if children.any? && products.any?
      errors.add(:base, "This category already has products and cannot add subcategories")
    end
  end

  def no_products_if_has_children
    if products.any? && children.any?
      errors.add(:base, "This category already has subcategories and cannot add products directly")
    end
  end

  # Extra protection: Check if parent already has products when saving parent
  validate :parent_must_not_have_products

  def parent_must_not_have_products
    if parent.present? && parent.products.any?
      errors.add(:parent_id, "Parent category already has products and cannot be used as a parent")
    end
  end
end
