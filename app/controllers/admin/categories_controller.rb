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
      redirect_to admin_categories_path, notice: "Category created successfully"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @category.update(category_params)
      redirect_to admin_categories_path, notice: "Category updated successfully"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @category.children.any?
      redirect_to admin_categories_path, alert: "Please delete subcategories first"
    elsif @category.products.any?
      redirect_to admin_categories_path, alert: "This category has products and cannot be deleted"
    else
      @category.destroy
      redirect_to admin_categories_path, notice: "Category deleted"
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
