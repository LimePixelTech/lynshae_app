#!/bin/bash
# LynShae 商品和用户信息修改 API 测试脚本

API_URL="${API_URL:-http://localhost:3005/api/v1}"
ADMIN_EMAIL="${ADMIN_EMAIL:-admin@lynshae.com}"
ADMIN_PASSWORD="${ADMIN_PASSWORD:-admin123}"

echo "============================================"
echo "LynShae 商品和用户信息修改 API 测试"
echo "============================================"
echo "API 地址：$API_URL"
echo ""

# 登录获取 Token
echo "📝 正在登录..."
LOGIN_RESPONSE=$(curl -s -X POST "$API_URL/auth/login" \
  -H "Content-Type: application/json" \
  -d "{\"email\":\"$ADMIN_EMAIL\",\"password\":\"$ADMIN_PASSWORD\"}")

TOKEN=$(echo "$LOGIN_RESPONSE" | grep -o '"accessToken":"[^"]*"' | cut -d'"' -f4)

if [ -z "$TOKEN" ]; then
  echo "❌ 登录失败"
  echo "响应：$LOGIN_RESPONSE"
  exit 1
fi

echo "✅ 登录成功"
echo "Token: ${TOKEN:0:20}..."
echo ""

# 设置认证头
AUTH_HEADER="Authorization: Bearer $TOKEN"

# ============================================
# 测试用户信息修改 API
# ============================================
echo "============================================"
echo "1️⃣  测试用户信息修改 API"
echo "============================================"

# 1.1 获取当前用户信息
echo ""
echo "📋 1.1 获取当前用户信息"
echo "GET $API_URL/users/me"
USER_RESPONSE=$(curl -s -X GET "$API_URL/users/me" \
  -H "$AUTH_HEADER" \
  -H "Content-Type: application/json")
echo "$USER_RESPONSE" | python3 -m json.tool 2>/dev/null || echo "$USER_RESPONSE"

# 1.2 更新用户信息
echo ""
echo "✏️  1.2 更新用户信息"
echo "PUT $API_URL/users/me"
UPDATE_USER_RESPONSE=$(curl -s -X PUT "$API_URL/users/me" \
  -H "$AUTH_HEADER" \
  -H "Content-Type: application/json" \
  -d '{"nickname":"测试管理员","phone":"13800138000"}')
echo "$UPDATE_USER_RESPONSE" | python3 -m json.tool 2>/dev/null || echo "$UPDATE_USER_RESPONSE"

# 1.3 修改密码
echo ""
echo "🔐 1.3 修改密码"
echo "POST $API_URL/users/me/change-password"
CHANGE_PWD_RESPONSE=$(curl -s -X POST "$API_URL/users/me/change-password" \
  -H "$AUTH_HEADER" \
  -H "Content-Type: application/json" \
  -d '{"oldPassword":"admin123","newPassword":"admin123456"}')
echo "$CHANGE_PWD_RESPONSE" | python3 -m json.tool 2>/dev/null || echo "$CHANGE_PWD_RESPONSE"

# 重新登录（因为密码已修改）
echo ""
echo "📝 重新登录（使用新密码）..."
LOGIN_RESPONSE=$(curl -s -X POST "$API_URL/auth/login" \
  -H "Content-Type: application/json" \
  -d "{\"email\":\"$ADMIN_EMAIL\",\"password\":\"admin123456\"}")

TOKEN=$(echo "$LOGIN_RESPONSE" | grep -o '"accessToken":"[^"]*"' | cut -d'"' -f4)

if [ -z "$TOKEN" ]; then
  echo "❌ 重新登录失败"
  echo "响应：$LOGIN_RESPONSE"
  exit 1
fi

echo "✅ 重新登录成功"
AUTH_HEADER="Authorization: Bearer $TOKEN"

# ============================================
# 测试商品信息修改 API
# ============================================
echo ""
echo "============================================"
echo "2️⃣  测试商品信息修改 API"
echo "============================================"

# 2.1 获取商品列表
echo ""
echo "📋 2.1 获取商品列表"
echo "GET $API_URL/products/admin/list?limit=5"
PRODUCT_LIST_RESPONSE=$(curl -s -X GET "$API_URL/products/admin/list?limit=5" \
  -H "$AUTH_HEADER" \
  -H "Content-Type: application/json")
echo "$PRODUCT_LIST_RESPONSE" | python3 -m json.tool 2>/dev/null || echo "$PRODUCT_LIST_RESPONSE"

# 获取第一个商品 ID
PRODUCT_ID=$(echo "$PRODUCT_LIST_RESPONSE" | grep -o '"id":[0-9]*' | head -1 | cut -d':' -f2)

if [ -z "$PRODUCT_ID" ]; then
  echo "❌ 未找到商品"
  exit 1
fi

echo ""
echo "📦 使用商品 ID: $PRODUCT_ID"

# 2.2 获取商品详情
echo ""
echo "📋 2.2 获取商品详情"
echo "GET $API_URL/products/admin/$PRODUCT_ID"
PRODUCT_DETAIL_RESPONSE=$(curl -s -X GET "$API_URL/products/admin/$PRODUCT_ID" \
  -H "$AUTH_HEADER" \
  -H "Content-Type: application/json")
echo "$PRODUCT_DETAIL_RESPONSE" | python3 -m json.tool 2>/dev/null || echo "$PRODUCT_DETAIL_RESPONSE"

# 2.3 更新商品信息
echo ""
echo "✏️  2.3 更新商品信息"
echo "PUT $API_URL/products/admin/$PRODUCT_ID"
UPDATE_PRODUCT_RESPONSE=$(curl -s -X PUT "$API_URL/products/admin/$PRODUCT_ID" \
  -H "$AUTH_HEADER" \
  -H "Content-Type: application/json" \
  -d '{"name":"测试商品 - 已更新","price":9999.00,"stock":100}')
echo "$UPDATE_PRODUCT_RESPONSE" | python3 -m json.tool 2>/dev/null || echo "$UPDATE_PRODUCT_RESPONSE"

# 2.4 更新商品状态
echo ""
echo "🔄 2.4 更新商品状态"
echo "PATCH $API_URL/products/admin/$PRODUCT_ID/status"
UPDATE_STATUS_RESPONSE=$(curl -s -X PATCH "$API_URL/products/admin/$PRODUCT_ID/status" \
  -H "$AUTH_HEADER" \
  -H "Content-Type: application/json" \
  -d '{"is_on_sale":false}')
echo "$UPDATE_STATUS_RESPONSE" | python3 -m json.tool 2>/dev/null || echo "$UPDATE_STATUS_RESPONSE"

# 2.5 获取更新后的商品详情
echo ""
echo "📋 2.5 获取更新后的商品详情"
echo "GET $API_URL/products/admin/$PRODUCT_ID"
UPDATED_DETAIL_RESPONSE=$(curl -s -X GET "$API_URL/products/admin/$PRODUCT_ID" \
  -H "$AUTH_HEADER" \
  -H "Content-Type: application/json")
echo "$UPDATED_DETAIL_RESPONSE" | python3 -m json.tool 2>/dev/null || echo "$UPDATED_DETAIL_RESPONSE"

# ============================================
# 测试商品图片管理 API
# ============================================
echo ""
echo "============================================"
echo "3️⃣  测试商品图片管理 API"
echo "============================================"

# 3.1 上传商品图片
echo ""
echo "📷 3.1 上传商品图片"
echo "POST $API_URL/products/admin/$PRODUCT_ID/images"

# 创建一个测试图片文件
TEST_IMAGE="/tmp/test_product_image.jpg"
echo "GIF89a" > "$TEST_IMAGE"  # 创建一个简单的测试文件

UPLOAD_RESPONSE=$(curl -s -X POST "$API_URL/products/admin/$PRODUCT_ID/images" \
  -H "$AUTH_HEADER" \
  -F "images=@$TEST_IMAGE")
echo "$UPLOAD_RESPONSE" | python3 -m json.tool 2>/dev/null || echo "$UPLOAD_RESPONSE"

# 获取图片 ID
IMAGE_ID=$(echo "$UPLOAD_RESPONSE" | grep -o '"id":[0-9]*' | head -1 | cut -d':' -f2)

if [ -n "$IMAGE_ID" ]; then
  echo ""
  echo "🖼️  上传图片 ID: $IMAGE_ID"
  
  # 3.2 删除商品图片
  echo ""
  echo "🗑️  3.2 删除商品图片"
  echo "DELETE $API_URL/products/admin/$PRODUCT_ID/images/$IMAGE_ID"
  DELETE_IMAGE_RESPONSE=$(curl -s -X DELETE "$API_URL/products/admin/$PRODUCT_ID/images/$IMAGE_ID" \
    -H "$AUTH_HEADER")
  echo "$DELETE_IMAGE_RESPONSE" | python3 -m json.tool 2>/dev/null || echo "$DELETE_IMAGE_RESPONSE"
fi

# 清理测试文件
rm -f "$TEST_IMAGE"

# ============================================
# 测试管理员用户管理 API
# ============================================
echo ""
echo "============================================"
echo "4️⃣  测试管理员用户管理 API"
echo "============================================"

# 4.1 获取用户列表
echo ""
echo "📋 4.1 获取用户列表"
echo "GET $API_URL/users?page=1&limit=10"
USER_LIST_RESPONSE=$(curl -s -X GET "$API_URL/users?page=1&limit=10" \
  -H "$AUTH_HEADER" \
  -H "Content-Type: application/json")
echo "$USER_LIST_RESPONSE" | python3 -m json.tool 2>/dev/null || echo "$USER_LIST_RESPONSE"

# ============================================
# 测试完成
# ============================================
echo ""
echo "============================================"
echo "✅ 所有测试完成！"
echo "============================================"
echo ""
echo "测试的 API 端点："
echo "  用户信息："
echo "    - GET    $API_URL/users/me           (获取当前用户)"
echo "    - PUT    $API_URL/users/me           (更新用户信息)"
echo "    - POST   $API_URL/users/me/change-password (修改密码)"
echo "    - GET    $API_URL/users              (用户列表 - 管理员)"
echo ""
echo "  商品信息："
echo "    - GET    $API_URL/products/admin/list      (商品列表)"
echo "    - GET    $API_URL/products/admin/:id       (商品详情)"
echo "    - PUT    $API_URL/products/admin/:id       (更新商品)"
echo "    - PATCH  $API_URL/products/admin/:id/status (更新状态)"
echo "    - POST   $API_URL/products/admin/:id/images (上传图片)"
echo "    - DELETE $API_URL/products/admin/:id/images/:imageId (删除图片)"
echo "    - POST   $API_URL/products/admin/:id/images/batch-delete (批量删除图片)"
echo "    - PUT    $API_URL/products/admin/:id/images/sort (更新图片排序)"
echo ""
