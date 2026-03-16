# LynShae 商品和用户信息修改 API 文档

## 概述

本文档描述 LynShae 系统的商品信息和用户信息修改相关的后端 API 接口。

**基础信息：**
- **Base URL**: `http://localhost:3005/api/v1`
- **认证方式**: JWT Bearer Token
- **数据格式**: JSON

---

## 认证说明

大部分修改操作需要用户登录认证。在请求头中添加：

```
Authorization: Bearer <your_jwt_token>
```

**获取 Token：**
```bash
POST /api/v1/auth/login
Content-Type: application/json

{
  "email": "admin@lynshae.com",
  "password": "admin123"
}
```

**响应：**
```json
{
  "success": true,
  "message": "登录成功",
  "data": {
    "user": {
      "id": 1,
      "username": "admin",
      "email": "admin@lynshae.com",
      "role": "super_admin"
    },
    "tokens": {
      "accessToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
      "refreshToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
    }
  }
}
```

---

## 用户信息修改 API

### 1. 获取当前用户信息

**端点：** `GET /users/me`

**认证：**  required

**响应：**
```json
{
  "success": true,
  "data": {
    "id": 1,
    "uuid": "00000000-0000-0000-0000-000000000001",
    "username": "admin",
    "email": "admin@lynshae.com",
    "avatar": "/uploads/avatars/admin.jpg",
    "role": "super_admin",
    "status": 1,
    "last_login_at": "2026-03-15T10:30:00.000Z",
    "created_at": "2026-03-15T00:00:00.000Z",
    "is_admin": true
  }
}
```

---

### 2. 更新当前用户信息

**端点：** `PUT /users/me`

**认证：** required

**请求体：**
```json
{
  "username": "new_username",      // 可选，3-50 字符
  "email": "new@email.com",        // 可选，有效邮箱
  "phone": "13800138000",          // 可选，仅普通用户，中国大陆手机号
  "nickname": "昵称",              // 可选，仅普通用户，最大 50 字符
  "gender": 1,                     // 可选，仅普通用户，0:未知 1:男 2:女
  "birthday": "1990-01-01",        // 可选，仅普通用户，日期格式
  "avatar": "/uploads/avatar.jpg"  // 可选，头像 URL
}
```

**响应：**
```json
{
  "success": true,
  "message": "用户信息更新成功"
}
```

**错误响应：**
```json
{
  "success": false,
  "message": "用户名已存在",
  "code": "DUPLICATE_USERNAME"
}
```

---

### 3. 修改密码

**端点：** `POST /users/me/change-password`

**认证：** required

**请求体：**
```json
{
  "oldPassword": "old_password_123",  // 必填，原密码
  "newPassword": "new_password_456"   // 必填，新密码（至少 6 位）
}
```

**响应：**
```json
{
  "success": true,
  "message": "密码修改成功"
}
```

**错误响应：**
```json
{
  "success": false,
  "message": "原密码错误",
  "code": "INVALID_PASSWORD"
}
```

---

### 4. 上传头像

**端点：** `POST /users/me/avatar`

**认证：** required

**Content-Type:** `multipart/form-data`

**请求参数：**
- `avatar`: 图片文件 (JPG/PNG/GIF)

**响应：**
```json
{
  "success": true,
  "message": "头像上传成功",
  "data": {
    "avatar": "/uploads/avatars/user_123.jpg"
  }
}
```

---

### 5. 获取用户列表（管理员）

**端点：** `GET /users`

**认证：** required (管理员权限)

**查询参数：**
- `page`: 页码 (默认 1)
- `limit`: 每页数量 (默认 20，最大 100)
- `keyword`: 搜索关键词 (用户名/邮箱/手机)
- `status`: 状态筛选 (0:禁用 1:正常)
- `role_id`: 角色 ID 筛选
- `sort`: 排序字段 (created_at/updated_at/last_login_at/username/email)
- `order`: 排序方向 (ASC/DESC)

**响应：**
```json
{
  "success": true,
  "data": {
    "users": [
      {
        "id": 2,
        "uuid": "00000000-0000-0000-0000-000000000002",
        "username": "test",
        "email": "test@lynshae.com",
        "phone": "13800138000",
        "nickname": "测试用户",
        "gender": 1,
        "avatar": null,
        "status": 1,
        "role_id": 3,
        "last_login_at": "2026-03-15T10:00:00.000Z",
        "email_verified": true,
        "phone_verified": false,
        "created_at": "2026-03-15T00:00:00.000Z",
        "updated_at": "2026-03-15T10:00:00.000Z"
      }
    ],
    "pagination": {
      "total": 10,
      "page": 1,
      "limit": 20,
      "totalPages": 1
    }
  }
}
```

---

### 6. 获取用户详情（管理员）

**端点：** `GET /users/:id`

**认证：** required (管理员权限)

**路径参数：**
- `id`: 用户 ID

**响应：** 同用户列表中的用户对象

---

### 7. 更新用户状态（管理员）

**端点：** `PATCH /users/:id/status`

**认证：** required (管理员权限)

**请求体：**
```json
{
  "status": 1  // 0:禁用 1:正常
}
```

**响应：**
```json
{
  "success": true,
  "message": "用户状态更新成功"
}
```

---

### 8. 删除用户（管理员）

**端点：** `DELETE /users/:id`

**认证：** required (管理员权限)

**说明：** 软删除，将 `deleted_at` 设置为当前时间

**响应：**
```json
{
  "success": true,
  "message": "用户删除成功"
}
```

---

## 商品信息修改 API

### 1. 获取商品列表

**端点：** `GET /products/admin/list`

**认证：** required

**查询参数：**
- `page`: 页码 (默认 1)
- `limit`: 每页数量 (默认 20)
- `category_id`: 分类 ID 筛选
- `status`: 状态筛选 (0:下架 1:上架)
- `keyword`: 搜索关键词 (商品名/SPU/型号)
- `sort`: 排序字段 (created_at/updated_at/price/sales_count/name/sort_order)
- `order`: 排序方向 (ASC/DESC)
- `is_recommend`: 是否推荐 (true/false)
- `is_hot`: 是否热销 (true/false)
- `is_new`: 是否新品 (true/false)
- `is_on_sale`: 是否在售 (true/false)
- `min_price`: 最低价格
- `max_price`: 最高价格

**响应：**
```json
{
  "success": true,
  "data": {
    "products": [
      {
        "id": 1,
        "spu": "LSD-PRO-001",
        "name": "灵羲机器狗 Pro",
        "category_id": 1,
        "category_name": "机器狗",
        "brand": "LynShae",
        "model": "LSD-PRO",
        "price": 9999.00,
        "original_price": 12999.00,
        "stock": 100,
        "images": ["/uploads/products/pro_1.jpg"],
        "is_new": true,
        "is_hot": true,
        "is_recommend": true,
        "is_on_sale": true,
        "status": 1,
        "created_at": "2026-03-15T00:00:00.000Z",
        "updated_at": "2026-03-15T10:00:00.000Z"
      }
    ],
    "pagination": {
      "total": 50,
      "page": 1,
      "limit": 20,
      "totalPages": 3
    }
  }
}
```

---

### 2. 获取商品详情

**端点：** `GET /products/admin/:id`

**认证：** required

**路径参数：**
- `id`: 商品 ID

**响应：**
```json
{
  "success": true,
  "data": {
    "id": 1,
    "spu": "LSD-PRO-001",
    "name": "灵羲机器狗 Pro",
    "category_id": 1,
    "category_name": "机器狗",
    "category_icon": "/icons/robot_dog.png",
    "brand": "LynShae",
    "model": "LSD-PRO",
    "short_description": "专业级智能机器狗",
    "content": "<p>商品详情 HTML</p>",
    "price": 9999.00,
    "original_price": 12999.00,
    "cost_price": 5000.00,
    "stock": 100,
    "warn_stock": 10,
    "unit": "件",
    "video_url": "/videos/pro_demo.mp4",
    "specs": {"weight": "5kg", "battery": "5000mAh"},
    "attributes": [{"name": "颜色", "value": "黑色"}],
    "tags": ["智能", "宠物", "高科技"],
    "is_new": true,
    "is_hot": true,
    "is_recommend": true,
    "is_on_sale": true,
    "sort_order": 1,
    "view_count": 1000,
    "sales_count": 50,
    "rating": 4.8,
    "images": [
      {"id": 1, "url": "/uploads/products/pro_1.jpg", "sort_order": 0, "is_primary": 1}
    ],
    "skus": [
      {"id": 1, "sku_code": "LSD-PRO-BLK", "specs": {"color": "黑色"}, "price": 9999.00, "stock": 50}
    ],
    "created_at": "2026-03-15T00:00:00.000Z",
    "updated_at": "2026-03-15T10:00:00.000Z"
  }
}
```

---

### 3. 创建商品

**端点：** `POST /products/admin`

**认证：** required

**Content-Type:** `multipart/form-data`

**请求参数：**
- `spu`: 商品 SPU 编号 (必填，唯一)
- `name`: 商品名称 (必填)
- `price`: 商品价格 (必填)
- `category_id`: 分类 ID (可选)
- `brand`: 品牌 (可选)
- `model`: 型号 (可选)
- `short_description`: 简短描述 (可选)
- `content`: 商品详情 HTML (可选)
- `original_price`: 原价 (可选)
- `cost_price`: 成本价 (可选)
- `stock`: 库存 (可选，默认 0)
- `warn_stock`: 预警库存 (可选，默认 10)
- `unit`: 单位 (可选，默认"件")
- `video_url`: 视频 URL (可选)
- `specs`: 规格参数 JSON (可选)
- `attributes`: 属性列表 JSON (可选)
- `tags`: 标签数组 JSON (可选)
- `is_new`: 是否新品 (可选，布尔)
- `is_hot`: 是否热销 (可选，布尔)
- `is_recommend`: 是否推荐 (可选，布尔)
- `is_on_sale`: 是否在售 (可选，布尔，默认 true)
- `sort_order`: 排序值 (可选，默认 0)
- `images`: 商品图片数组 (可选，最多 10 张)
- `skus`: SKU 数组 (可选)

**响应：**
```json
{
  "success": true,
  "message": "商品创建成功",
  "data": {
    "id": 1,
    "spu": "LSD-PRO-001"
  }
}
```

---

### 4. 更新商品信息

**端点：** `PUT /products/admin/:id`

**认证：** required

**Content-Type:** `multipart/form-data` 或 `application/json`

**路径参数：**
- `id`: 商品 ID

**请求参数：** (同创建商品，所有字段可选)

**响应：**
```json
{
  "success": true,
  "message": "商品更新成功"
}
```

**错误响应：**
```json
{
  "success": false,
  "message": "SPU 已存在",
  "code": "DUPLICATE_SPU"
}
```

---

### 5. 更新商品状态

**端点：** `PATCH /products/admin/:id/status`

**认证：** required

**请求体：**
```json
{
  "status": 1,        // 0:下架 1:上架
  "is_on_sale": true  // 是否在售
}
```

**响应：**
```json
{
  "success": true,
  "message": "状态更新成功"
}
```

---

### 6. 上传商品图片

**端点：** `POST /products/admin/:id/images`

**认证：** required

**Content-Type:** `multipart/form-data`

**路径参数：**
- `id`: 商品 ID

**请求参数：**
- `images`: 图片文件数组 (最多 10 张)

**响应：**
```json
{
  "success": true,
  "message": "图片上传成功",
  "data": {
    "count": 3,
    "images": [
      {"url": "/uploads/products/img_1.jpg"},
      {"url": "/uploads/products/img_2.jpg"},
      {"url": "/uploads/products/img_3.jpg"}
    ]
  }
}
```

---

### 7. 删除商品图片

**端点：** `DELETE /products/admin/:id/images/:imageId`

**认证：** required

**路径参数：**
- `id`: 商品 ID
- `imageId`: 图片 ID

**响应：**
```json
{
  "success": true,
  "message": "图片删除成功"
}
```

---

### 8. 批量删除商品图片

**端点：** `POST /products/admin/:id/images/batch-delete`

**认证：** required

**请求体：**
```json
{
  "imageIds": [1, 2, 3]
}
```

**响应：**
```json
{
  "success": true,
  "message": "成功删除 3 张图片"
}
```

---

### 9. 更新商品图片排序

**端点：** `PUT /products/admin/:id/images/sort`

**认证：** required

**请求体：**
```json
{
  "images": [
    {"id": 1, "sort_order": 0},
    {"id": 2, "sort_order": 1},
    {"id": 3, "sort_order": 2}
  ]
}
```

**响应：**
```json
{
  "success": true,
  "message": "图片排序更新成功"
}
```

---

### 10. 更新商品 SKU

**端点：** `PUT /products/admin/:id/skus`

**认证：** required

**请求体：**
```json
{
  "skus": [
    {
      "sku_code": "LSD-PRO-BLK",
      "specs": {"color": "黑色"},
      "price": 9999.00,
      "original_price": 12999.00,
      "stock": 50,
      "image": "/uploads/sku/black.jpg",
      "is_active": true
    },
    {
      "sku_code": "LSD-PRO-WHT",
      "specs": {"color": "白色"},
      "price": 9999.00,
      "original_price": 12999.00,
      "stock": 30,
      "image": "/uploads/sku/white.jpg",
      "is_active": true
    }
  ]
}
```

**响应：**
```json
{
  "success": true,
  "message": "SKU 更新成功"
}
```

---

### 11. 删除商品

**端点：** `DELETE /products/admin/:id`

**认证：** required

**说明：** 软删除，将 `deleted_at` 设置为当前时间，同时设置 `status=0` 和 `is_on_sale=0`

**响应：**
```json
{
  "success": true,
  "message": "商品删除成功"
}
```

---

### 12. 批量删除商品

**端点：** `POST /products/admin/batch-delete`

**认证：** required

**请求体：**
```json
{
  "ids": [1, 2, 3]
}
```

**响应：**
```json
{
  "success": true,
  "message": "成功删除 3 个商品"
}
```

---

## 错误码说明

| 错误码 | 说明 | HTTP 状态码 |
|--------|------|-----------|
| UNAUTHORIZED | 未授权/未登录 | 401 |
| FORBIDDEN | 权限不足 | 403 |
| NOT_FOUND | 资源不存在 | 404 |
| DUPLICATE_USERNAME | 用户名已存在 | 409 |
| DUPLICATE_EMAIL | 邮箱已存在 | 409 |
| DUPLICATE_PHONE | 手机号已存在 | 409 |
| DUPLICATE_SPU | SPU 已存在 | 409 |
| INVALID_PASSWORD | 密码错误 | 400 |
| PASSWORD_TOO_SHORT | 密码太短 | 400 |
| INVALID_STATUS | 无效的状态值 | 400 |
| NO_FILES_UPLOADED | 未上传文件 | 400 |
| IMAGE_NOT_FOUND | 图片不存在 | 404 |

---

## 测试脚本

使用提供的测试脚本快速验证 API：

```bash
cd /Users/freakk/.nanobot/workspace/lynshae
./test-update-apis.sh
```

环境变量：
- `API_URL`: API 地址 (默认 http://localhost:3005/api/v1)
- `ADMIN_EMAIL`: 管理员邮箱 (默认 admin@lynshae.com)
- `ADMIN_PASSWORD`: 管理员密码 (默认 admin123)

---

## 注意事项

1. **非必需登录**: 应用可以在未登录状态下使用，只有修改操作需要认证
2. **Token 有效期**: Access Token 默认 7 天，Refresh Token 默认 30 天
3. **文件上传**: 图片上传使用 multipart/form-data 格式
4. **软删除**: 用户和商品删除均为软删除，保留数据但标记为已删除
5. **缓存**: 修改操作会自动清除相关缓存
6. **事务**: 涉及多表操作的使用数据库事务保证一致性

---

## 更新日志

**2026-03-15**
- ✅ 新增用户信息修改 API
- ✅ 新增用户密码修改 API
- ✅ 新增用户头像上传 API
- ✅ 新增商品图片批量删除 API
- ✅ 新增商品图片排序 API
- ✅ 优化可选认证中间件
- ✅ 完善错误处理和验证
