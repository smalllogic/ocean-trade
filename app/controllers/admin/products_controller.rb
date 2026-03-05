class Admin::ProductsController < Admin::BaseController
  before_action :set_product, only: [:show, :edit, :update, :destroy, :remove_image]
  
  def index
    @products = Product.includes(:category).ordered_by_newest
  end
  
  def show
  end
  
  def new
    @product = Product.new
    @product.variants.build # 默认创建一个变体
  end
  
  def create
    @product = Product.new(product_params.except(:images))
    
    if @product.save
      @product.images.attach(params[:product][:images]) if params[:product][:images].present?
      redirect_to admin_product_path(@product), notice: "Product created successfully"
    else
      render :new, status: :unprocessable_entity
    end
  end
  
  def edit
  end
  
  def update
    # 如果有新图片上传，则追加而不是替换现有图片
    if params[:product][:images].present?
      @product.images.attach(params[:product][:images])
    end

    # 排除 images，因为已经手动 attach 了
    if @product.update(product_params.except(:images))
      redirect_to admin_product_path(@product), notice: "Product updated successfully"
    else
      render :edit, status: :unprocessable_entity
    end
  end
  
  def destroy
    @product.destroy
    redirect_to admin_products_path, notice: "Product deleted successfully"
  end

  def remove_image
    image = @product.images.find(params[:image_id])
    image.purge
    redirect_back fallback_location: edit_admin_product_path(@product), notice: "Image removed"
  end
  
  private
  
  def set_product
    @product = Product.find(params[:id])
  end
  
  def product_params
    params.require(:product).permit(
      :name, :price, :description, :summary, :product_type, :sort_order, :is_hidden, :category_id, 
      images: [], 
      variants_attributes: [:id, :title, :price, :stock, :sku, :position, :length, :capacity, :is_active, :_destroy]
    )
  end
end
