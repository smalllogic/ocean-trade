# 订单系统文档 (Order System Documentation)

## 概述 (Overview)
游客版订单系统，允许未登录用户直接下单购买商品。

## 数据模型 (Data Models)

### Order (订单)
- `total_price` (decimal): 订单总金额，精度 10 位，小数 2 位
- `status` (string): 订单状态 (pending, paid, shipped, completed)
- `name` (string): 收货人姓名
- `email` (string): 联系邮箱
- `phone` (string): 联系电话
- `address` (text): 配送地址

**关联关系:**
- `has_many :order_items` - 一个订单包含多个订单项
- `has_many :products, through: :order_items` - 通过订单项关联产品

**状态方法:**
- `pending?` - 待支付
- `paid?` - 已支付
- `shipped?` - 已发货
- `completed?` - 已完成

### OrderItem (订单项)
- `order_id` (references): 所属订单
- `product_id` (references): 关联产品
- `price` (decimal): 下单时冻结的商品价格
- `quantity` (integer): 购买数量

**关联关系:**
- `belongs_to :order` - 属于某个订单
- `belongs_to :product` - 关联某个产品

**方法:**
- `subtotal` - 计算小计 (price × quantity)

## 核心功能 (Core Features)

### 1. 购物车转订单 (Cart → Order)
在 `Cart` 模型中实现的 `build_order` 方法：

```ruby
def build_order(order_params = {})
  order = Order.new(order_params)
  order.status = "pending"
  
  cart_items.includes(:product).each do |cart_item|
    order.order_items.build(
      product: cart_item.product,
      price: cart_item.product.price,  # 冻结当前价格
      quantity: cart_item.quantity
    )
  end
  
  order.total_price = order.order_items.sum { |item| item.price * item.quantity }
  order
end
```

**特点:**
- 冻结下单时的商品价格，避免价格变动影响订单
- 自动计算订单总价
- 保留购买数量信息

### 2. 结账流程 (Checkout Flow)

#### 路由 (Routes)
```ruby
resources :orders, only: [:new, :create, :show]
```

#### 控制器 (OrdersController)
- `new` - 显示订单确认页面，填写联系信息
- `create` - 创建订单，清空购物车
- `show` - 订单详情页面（确认页）

**安全措施:**
- `before_action :check_cart_not_empty` - 防止空购物车结账

### 3. 视图页面 (Views)

#### 订单确认页 (`orders/new.html.erb`)
- 左侧：联系人信息表单（姓名、邮箱、手机、地址）
- 右侧：订单摘要（商品列表、价格明细）
- 表单验证：所有字段必填

#### 订单详情页 (`orders/show.html.erb`)
- 订单号和状态显示
- 联系人信息展示
- 配送地址展示
- 商品清单表格
- 订单总额汇总
- 支付按钮（待实现）

## 使用流程 (User Flow)

1. **浏览商品** → 选择商品加入购物车
2. **查看购物车** (`/cart`) → 点击"去结账"按钮
3. **填写订单信息** (`/orders/new`) → 输入联系信息和地址
4. **提交订单** → 创建订单，清空购物车
5. **订单确认** (`/orders/:id`) → 查看订单详情
6. **支付** → 点击"立即支付"（待集成支付功能）

## 待完成功能 (TODO)

- [ ] 支付功能集成 (Payment Integration)
- [ ] 订单状态管理 (Order Status Management)
- [ ] 邮件通知 (Email Notifications)
- [ ] 订单查询 (Order Tracking)
- [ ] 管理后台订单管理 (Admin Order Management)
- [ ] 购物车商品数量修改和删除 (Cart Item Update/Delete)

## 数据库索引 (Database Indexes)

为提升查询性能，已添加以下索引：
- `orders` 表: `status` 字段索引
- `orders` 表: `email` 字段索引
- `order_items` 表: `order_id` 外键索引
- `order_items` 表: `product_id` 外键索引

## 测试建议 (Testing Recommendations)

1. 测试空购物车结账 - 应被拦截
2. 测试商品价格变化 - 订单应保留下单时价格
3. 测试表单验证 - 所有字段必填
4. 测试订单创建后购物车清空
5. 测试订单号生成唯一性

## 安全考虑 (Security Considerations)

- 使用 `session[:cart_id]` 存储购物车，避免跨用户数据泄露
- 订单项价格在下单时冻结，防止恶意篡改
- 强参数 (Strong Parameters) 限制可修改字段
- Email 格式验证
- 所有金额使用 `decimal` 类型，避免浮点数精度问题
