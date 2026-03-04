class Admin::CategoriesController < Admin::BaseController
  before_action :set_category, only: [:edit, :update, :destroy]

  def index
    @categories = Category.where(parent_id: nil).includes(:children)
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      redirect_to admin_categories_path, notice: "分类创建成功"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @category.update(category_params)
      redirect_to admin_categories_path, notice: "分类更新成功"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @category.children.any?
      redirect_to admin_categories_path, alert: "请先删除子分类"
    elsif @category.products.any?
      redirect_to admin_categories_path, alert: "该分类下仍有产品，无法删除"
    else
      @category.destroy
      redirect_to admin_categories_path, notice: "分类已删除"
    end
  end

  private

  def set_category
    @category = Category.find(params[:id])
  end

  def category_params
    params.require(:category).permit(:name, :parent_id)
  end
end
