require "test_helper"

class CategoryConstraintTest < ActiveSupport::TestCase
  setup do
    @parent = Category.create!(name: "Parent")
    @child = Category.create!(name: "Child", parent: @parent)
  end

  test "product can only be assigned to leaf category" do
    # Parent has a child, so it's not a leaf
    product = Product.new(name: "Test Product", price: 10, category: @parent)
    assert_not product.valid?
    assert_includes product.errors[:category_id], "必须是底层（叶子）分类，不能挂在有子分类的节点下"

    # Child is a leaf
    product.category = @child
    assert product.valid?
  end

  test "category cannot have children if it has products" do
    # Assign product to @child (which is currently a leaf)
    Product.create!(name: "Leaf Product", price: 10, category: @child)
    
    # Try to add a grandchild to @child
    grandchild = Category.new(name: "Grandchild", parent: @child)
    assert_not grandchild.valid?
    # Based on my implementation: validate :no_children_if_has_products in Category
    # Since adding a grandchild makes @child have children, and it already has products
    assert_includes grandchild.errors[:base], "该分类下已有产品，不能添加子分类"
  end

  test "category cannot have products if it has children" do
    # @parent already has @child
    product = Product.new(name: "Parent Product", price: 10, category: @parent)
    assert_not product.valid?
    # This is caught by Product's category_must_be_leaf validation
  end
end
