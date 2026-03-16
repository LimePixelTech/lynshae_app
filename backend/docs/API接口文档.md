# LynShae API 文档

> API Version: 1.0.0 | Base URL: `/api/v1`

---

## 📋 目录

- [概览](#概览)
- [认证说明](#认证说明)
- [错误码](#错误码)
- [接口列表](#接口列表)

---

## 概览

### 请求格式

所有 API 请求使用 JSON 格式：

```http
Content-Type: application/json
Accept: application/json
```

### 响应格式

所有 API 响应遵循统一格式：

```json
{
  "code": "SUCCESS",
  "message": "操作成功",
  "data": {}
}
```

### 分页参数

列表接口支持分页：

| 参数 | 类型 | 默认值 | 说明 |
|------|------|--------|------|
| page | integer | 1 | 页码 |
| limit | integer | 20 | 每页数量 |

---

## 认证说明

### JWT Token

使用 Bearer Token 进行认证：

```http
Authorization: Bearer <accessToken>
```

### Token 有效期

- **Access Token**: 7 天
- **Refresh Token**: 30 天

### Token 刷新

```http
POST /api/v1/auth/refresh-token
Content-Type: application/json

{
  "refreshToken": "eyJhbGc..."
}
```

---

## 错误码

| 错误码 | HTTP 状态码 | 说明 |
|--------|-----------|------|
| SUCCESS | 200 | 成功 |
| VALIDATION_ERROR | 400 | 参数验证失败 |
| UNAUTHORIZED | 401 | 未认证 |
| FORBIDDEN | 403 | 无权限 |
| NOT_FOUND | 404 | 资源不存在 |
| DUPLICATE_ENTRY | 400 | 数据重复 |
| INTERNAL_ERROR | 500 | 服务器错误 |

---

## 接口列表

### 🔐 认证接口

#### POST `/auth/register` - 用户注册

**请求体**:
```json
{
  "username": "testuser",
  "email": "test@example.com",
  "password": "password123"
}
```

**响应**:
```json
{
  "code": "SUCCESS",
  "message": "注册成功",
  "data": {
    "uuid": "xxx-xxx-xxx",
    "username": "testuser",
    "email": "test@example.com"
  }
}
```

---

#### POST `/auth/login` - 用户登录

**请求体**:
```json
{
  "email": "test@example.com",
  "password": "password123"
}
```

**响应**:
```json
{
  "code": "SUCCESS",
  "message": "登录成功",
  "data": {
    "user": {
      "id": 1,
      "uuid": "xxx-xxx-xxx",
      "username": "testuser",
      "email": "test@example.com",
      "roleId": 3
    },
    "tokens": {
      "accessToken": "eyJhbGc...",
      "refreshToken": "eyJhbGc...",
      "expiresIn": "7d"
    }
  }
}
```

---

#### POST `/auth/logout` - 用户登出

**Headers**:
```
Authorization: Bearer <accessToken>
```

**响应**:
```json
{
  "code": "SUCCESS",
  "message": "登出成功"
}
```

---

#### GET `/auth/me` - 获取当前用户

**Headers**:
```
Authorization: Bearer <accessToken>
```

**响应**:
```json
{
  "code": "SUCCESS",
  "data": {
    "id": 1,
    "uuid": "xxx-xxx-xxx",
    "username": "testuser",
    "email": "test@example.com",
    "avatar": "https://...",
    "nickname": "测试用户"
  }
}
```

---

#### PUT `/auth/password` - 修改密码

**Headers**:
```
Authorization: Bearer <accessToken>
```

**请求体**:
```json
{
  "currentPassword": "old123456",
  "newPassword": "new123456"
}
```

---

### 🛍️ 商品接口

#### GET `/products` - 获取商品列表

**查询参数**:
| 参数 | 类型 | 说明 |
|------|------|------|
| page | integer | 页码 |
| limit | integer | 每页数量 |
| categoryId | integer | 分类 ID |
| keyword | string | 搜索关键词 |
| isOnSale | boolean | 是否上架 |
| isNew | boolean | 是否新品 |
| isHot | boolean | 是否热卖 |
| sortBy | string | 排序字段 |
| order | string | 排序方向 (ASC/DESC) |

**响应**:
```json
{
  "code": "SUCCESS",
  "data": {
    "products": [
      {
        "id": 1,
        "spu": "SPU202603140001",
        "name": "机器狗 Pro",
        "price": 9999.00,
        "original_price": 12999.00,
        "stock": 100,
        "images": ["url1", "url2"],
        "category_name": "机器狗",
        "is_on_sale": true,
        "is_new": true,
        "sales_count": 520
      }
    ],
    "pagination": {
      "page": 1,
      "limit": 20,
      "total": 100,
      "totalPages": 5
    }
  }
}
```

---

#### GET `/products/:id` - 获取商品详情

**响应**:
```json
{
  "code": "SUCCESS",
  "data": {
    "id": 1,
    "spu": "SPU202603140001",
    "name": "机器狗 Pro",
    "description": "详细描述...",
    "content": "<p>详情 HTML</p>",
    "price": 9999.00,
    "stock": 100,
    "images": ["url1", "url2"],
    "specs": { "颜色": "黑色", "尺寸": "标准" },
    "skus": [
      {
        "id": 1,
        "sku_code": "SKU001",
        "specs": { "颜色": "黑色" },
        "price": 9999.00,
        "stock": 50
      }
    ]
  }
}
```

---

#### POST `/products` - 创建商品（管理员）

**Headers**:
```
Authorization: Bearer <accessToken>
Content-Type: multipart/form-data
```

**请求体**:
| 字段 | 类型 | 必填 | 说明 |
|------|------|------|------|
| name | string | 是 | 商品名称 |
| price | number | 是 | 价格 |
| category_id | integer | 否 | 分类 ID |
| brand | string | 否 | 品牌 |
| short_description | string | 否 | 简短描述 |
| description | string | 否 | 详细描述 |
| content | string | 否 | 详情 HTML |
| stock | integer | 否 | 库存 |
| images | file[] | 否 | 商品图片 |

---

#### PUT `/products/:id` - 更新商品（管理员）

**Headers**:
```
Authorization: Bearer <accessToken>
```

---

#### DELETE `/products/:id` - 删除商品（管理员）

**Headers**:
```
Authorization: Bearer <accessToken>
```

---

#### PATCH `/products/:id/sale` - 上架/下架（管理员）

**请求体**:
```json
{
  "isOnSale": true
}
```

---

#### GET `/products/categories` - 获取分类

**响应**:
```json
{
  "code": "SUCCESS",
  "data": [
    {
      "id": 1,
      "name": "机器狗",
      "code": "robot_dog",
      "level": 1,
      "children": [
        {
          "id": 2,
          "name": "机器狗 Pro",
          "parent_id": 1,
          "level": 2
        }
      ]
    }
  ]
}
```

---

### 🤖 设备接口

#### GET `/devices` - 获取设备列表

**Headers**:
```
Authorization: Bearer <accessToken>
```

---

#### GET `/devices/:id` - 获取设备详情

---

#### POST `/devices/:id/bind` - 绑定设备

**请求体**:
```json
{
  "bindCode": "ABC123"
}
```

---

#### POST `/devices/:id/control` - 控制设备

**请求体**:
```json
{
  "action": "move_forward",
  "params": { "speed": 0.5, "duration": 1000 }
}
```

---

### 📦 订单接口

#### GET `/orders` - 获取订单列表

**查询参数**:
| 参数 | 类型 | 说明 |
|------|------|------|
| status | integer | 订单状态 |
| page | integer | 页码 |
| limit | integer | 每页数量 |

---

#### GET `/orders/:id` - 获取订单详情

---

#### POST `/orders` - 创建订单

**请求体**:
```json
{
  "items": [
    {
      "productId": 1,
      "skuId": 1,
      "quantity": 1
    }
  ],
  "receiverName": "张三",
  "receiverPhone": "13800138000",
  "receiverAddress": "北京市朝阳区 xxx"
}
```

---

### 👤 用户接口

#### GET `/users/me` - 获取当前用户信息

---

#### PUT `/users/me` - 更新用户信息

**请求体**:
```json
{
  "nickname": "新昵称",
  "avatar": "https://..."
}
```

---

## 📊 订单状态

| 状态码 | 说明 |
|--------|------|
| 0 | 待付款 |
| 1 | 待发货 |
| 2 | 待收货 |
| 3 | 已完成 |
| 4 | 已取消 |
| 5 | 已退款 |

---

*最后更新：2026-03-14*
