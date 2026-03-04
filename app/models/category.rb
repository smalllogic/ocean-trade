class Category < ApplicationRecord
  has_many :children, class_name: "Category", foreign_key: "parent_id", dependent: :destroy
  belongs_to :parent, class_name: "Category", optional: true
  has_many :products

  validates :name, presence: true

  # 业务约束 2: Category 的 parent 若已有 product 则不允许再添加 children
  validate :no_children_if_has_products
  # 业务约束 (延伸): 如果已有子分类，不允许直接挂载产品 (在 Product 模型中校验更直接，但这里也加一个保护)
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
      errors.add(:base, "该分类下已有产品，不能添加子分类")
    end
  end

  def no_products_if_has_children
    if products.any? && children.any?
      errors.add(:base, "该分类已有子分类，不能直接添加产品")
    end
  end

  # 额外保护：在保存 parent 时检查 parent 是否已有产品
  validate :parent_must_not_have_products

  def parent_must_not_have_products
    if parent.present? && parent.products.any?
      errors.add(:parent_id, "上级分类已有产品，不能作为父分类")
    end
  end
end
