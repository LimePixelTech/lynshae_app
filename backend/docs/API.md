# LynShae API 文档

## 基础信息

- **Base URL**: `http://localhost:3000/api`
- **认证方式**: JWT Bearer Token
- **数据格式**: JSON

## 认证

### 获取 Token

```http
POST /api/auth/login
Content-Type: application/json

{
  "username": "admin",
  "password": "admin123"
}
```

**响应**:
```json
{
  "success": true,
  "message": "登录成功",
  "data": {
    "admin": {
      "id": 1,
      "username": "admin",
      "email": "admin@lynshae.com",
      "role": 1
    },
    "accessToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "refreshToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "expiresIn": "2h"
  }
}
```

### 使用 Token

在所有需要认证的请求中，添加 Authorization 头：

```http
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

---

## 商品管理

### 获取商品列表

```http
GET /api/products?page=1&limit=20&category_id=1&status=1&keyword=机器狗
```

**查询参数**:
| 参数 | 类型 | 说明 |
|------|------|------|
| page | int | 页码，默认 1 |
| limit | int | 每页数量，默认 20，最大 100 |
| category_id | int | 分类 ID 筛选 |
| brand_id | int | 品牌 ID 筛选 |
| status | int | 状态：0=下架，1=上架 |
| keyword | string | 搜索关键词 (名称/简介/SKU) |
| sort | string | 排序字段：created_at/price/sales/name |
| order | string | 排序方向：ASC/DESC |
| min_price | float | 最低价格 |
| max_price | float | 最高价格 |
| is_recommend | int | 是否推荐 |
| is_hot | int | 是否热销 |
| is_new | int | 是否新品 |

**响应**:
```json
{
  "success": true,
  "data": {
    "products": [
      {
        "id": 1,
        "name": "灵羲机器狗 X1",
        "category_id": 1,
        "category_name": "机器狗",
        "brand_id": 1,
        "brand_name": "LynShae",
        "sku": "LX-X1-001",
        "price": 9999.00,
        "original_price": 12999.00,
        "stock": 100,
        "sales": 520,
        "description": "高性能智能机器狗",
        "main_image": "/uploads/2026/03/xxx.jpg",
        "images": ["/uploads/2026/03/xxx.jpg", ...],
        "status": 1,
        "is_recommend": 1,
        "is_hot": 1,
        "is_new": 1,
        "created_at": "2026-03-14T10:00:00.000Z"
      }
    ],
    "pagination": {
      "total": 100,
      "page": 1,
      "limit": 20,
      "totalPages": 5
    }
  }
}
```

### 获取商品详情

```http
GET /api/products/:id
```

**响应**:
```json
{
  "success": true,
  "data": {
    "id": 1,
    "name": "灵羲机器狗 X1",
    "category_id": 1,
    "category_name": "机器狗",
    "brand_id": 1,
    "brand_name": "LynShae",
    "sku": "LX-X1-001",
    "price": 9999.00,
    "original_price": 12999.00,
    "stock": 100,
    "sales": 520,
    "description": "高性能智能机器狗",
    "details": "<p>详细介绍...</p>",
    "main_image": "/uploads/2026/03/xxx.jpg",
    "images": [
      {"id": 1, "url": "/uploads/2026/03/xxx.jpg", "sort_order": 0, "is_primary": 1},
      {"id": 2, "url": "/uploads/2026/03/yyy.jpg", "sort_order": 1, "is_primary": 0}
    ],
    "specs": [
      {"id": 1, "spec_name": "颜色", "spec_value": "黑色"},
      {"id": 2, "spec_name": "尺寸", "spec_value": "标准版"}
    ],
    "skus": [
      {"id": 1, "sku_code": "LX-X1-001-BLK", "specs": {"颜色": "黑色"}, "price": 9999.00, "stock": 50}
    ],
    "status": 1,
    "created_at": "2026-03-14T10:00:00.000Z",
    "updated_at": "2026-03-14T12:00:00.000Z"
  }
}
```

### 创建商品

```http
POST /api/products
Content-Type: multipart/form-data

name: 灵羲机器狗 X1
category_id: 1
brand_id: 1
sku: LX-X1-001
price: 9999.00
original_price: 12999.00
stock: 100
description: 高性能智能机器狗
details: <p>详细介绍...</p>
is_recommend: 1
is_hot: 1
is_new: 1
images: [file1, file2, ...]
```

**响应**:
```json
{
  "success": true,
  "message": "商品创建成功",
  "data": {
    "id": 1
  }
}
```

### 更新商品

```http
PUT /api/products/:id
Content-Type: multipart/form-data

name: 灵羲机器狗 X1 升级版
price: 8999.00
stock: 150
images: [file1, file2, ...]
```

**响应**:
```json
{
  "success": true,
  "message": "商品更新成功"
}
```

### 删除商品

```http
DELETE /api/products/:id
```

**响应**:
```json
{
  "success": true,
  "message": "商品删除成功"
}
```

### 更新商品状态

```http
PATCH /api/products/:id/status
Content-Type: application/json

{
  "status": 0
}
```

### 上传商品图片

```http
POST /api/products/:id/images
Content-Type: multipart/form-data

images: [file1, file2, ...]
```

### 删除商品图片

```http
DELETE /api/products/:id/images/:imageId
```

### 获取热销商品

```http
GET /api/products/recommend/hot?limit=10
```

### 获取新品推荐

```http
GET /api/products/recommend/new?limit=10
```

---

## 分类管理

### 获取分类列表

```http
GET /api/categories?parent_id=1&status=1
```

### 获取分类树

```http
GET /api/categories/tree
```

**响应**:
```json
{
  "success": true,
  "data": [
    {
      "id": 1,
      "name": "机器狗",
      "parent_id": null,
      "level": 1,
      "children": [
        {
          "id": 2,
          "name": "小型机器狗",
          "parent_id": 1,
          "level": 2,
          "children": []
        }
      ]
    }
  ]
}
```

### 创建分类

```http
POST /api/categories
Content-Type: application/json

{
  "name": "机器狗",
  "parent_id": null,
  "icon": "/icons/dog.svg",
  "sort_order": 1
}
```

### 更新分类

```http
PUT /api/categories/:id
Content-Type: application/json

{
  "name": "智能机器狗",
  "sort_order": 2
}
```

### 删除分类

```http
DELETE /api/categories/:id
```

---

## 品牌管理

### 获取品牌列表

```http
GET /api/brands?status=1&keyword=LynShae
```

### 获取品牌详情

```http
GET /api/brands/:id
```

### 创建品牌

```http
POST /api/brands
Content-Type: application/json

{
  "name": "LynShae",
  "logo": "/uploads/brands/lynshae.png",
  "description": "灵羲智能品牌",
  "website": "https://lynshae.com"
}
```

### 更新品牌

```http
PUT /api/brands/:id
Content-Type: application/json

{
  "name": "LynShae 灵羲",
  "description": " updated description"
}
```

### 删除品牌

```http
DELETE /api/brands/:id
```

---

## 文件上传

### 上传单张图片

```http
POST /api/upload/image
Content-Type: multipart/form-data

image: [file]
```

**响应**:
```json
{
  "success": true,
  "message": "上传成功",
  "data": {
    "url": "/uploads/2026/03/xxx.jpg",
    "filename": "uuid.jpg",
    "size": 102400,
    "mimetype": "image/jpeg"
  }
}
```

### 上传多张图片

```http
POST /api/upload/images
Content-Type: multipart/form-data

images: [file1, file2, ...]
```

### 删除文件

```http
DELETE /api/upload/:filename
```

---

## 系统管理

### 获取系统配置

```http
GET /api/system/configs
```

**响应**:
```json
{
  "success": true,
  "data": {
    "site_name": "LynShae 商品管理系统",
    "site_logo": "/assets/logo.png",
    "copyright": "© 2026 LynShae",
    "max_upload_size": 10485760,
    "items_per_page": 20
  }
}
```

### 更新系统配置

```http
PUT /api/system/configs
Content-Type: application/json

{
  "site_name": "新系统名称",
  "items_per_page": 50
}
```

### 获取操作日志

```http
GET /api/system/logs?page=1&limit=50&admin_id=1&action=login
```

### 获取系统统计

```http
GET /api/system/stats
```

**响应**:
```json
{
  "success": true,
  "data": {
    "products": {
      "total": 100,
      "on_sale": 80,
      "off_sale": 20,
      "new_products": 10,
      "hot_products": 5,
      "recommended": 8
    },
    "categories": {
      "total": 10,
      "active": 9
    },
    "brands": {
      "total": 5,
      "active": 5
    },
    "stock": {
      "total_stock": 5000,
      "total_sales": 1200
    },
    "sales": [
      {"date": "2026-03-14", "count": 10, "amount": 99990.00}
    ]
  }
}
```

### 清除缓存

```http
POST /api/system/cache/clear
Content-Type: application/json

{
  "pattern": "product:*"
}
```

---

## 错误响应

### 标准错误格式

```json
{
  "success": false,
  "message": "错误信息",
  "code": "ERROR_CODE"
}
```

### 常见错误码

| 错误码 | HTTP 状态码 | 说明 |
|--------|------------|------|
| VALIDATION_ERROR | 400 | 数据验证失败 |
| UNAUTHORIZED | 401 | 未认证 |
| TOKEN_EXPIRED | 401 | Token 过期 |
| INVALID_TOKEN | 401 | 无效 Token |
| FORBIDDEN | 403 | 权限不足 |
| NOT_FOUND | 404 | 资源不存在 |
| DUPLICATE_ENTRY | 409 | 重复数据 |
| INTERNAL_ERROR | 500 | 服务器错误 |

---

## 速率限制

- 普通接口：100 请求/分钟/IP
- 登录接口：5 请求/15 分钟/IP

超出限制会返回 429 状态码：

```json
{
  "success": false,
  "message": "请求过于频繁，请稍后再试",
  "retryAfter": 60
}
```
