#!/bin/bash
# LynShae 登录测试脚本

echo "=== LynShae 登录测试 ==="
echo ""

# 测试登录接口
echo "1. 测试登录接口..."
RESPONSE=$(curl -s -X POST http://localhost:3005/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"admin@lynshae.com","password":"admin123"}')

echo "响应：$RESPONSE"
echo ""

# 检查响应是否成功
if echo "$RESPONSE" | grep -q '"success":true'; then
    echo "✅ 登录接口测试通过"
else
    echo "❌ 登录接口测试失败"
    exit 1
fi

# 提取 Token
TOKEN=$(echo "$RESPONSE" | grep -o '"accessToken":"[^"]*"' | cut -d'"' -f4)
echo ""
echo "2. Access Token: ${TOKEN:0:50}..."
echo ""

# 测试认证接口
echo "3. 测试认证接口（获取当前用户）..."
USER_RESPONSE=$(curl -s -X GET http://localhost:3005/api/v1/auth/me \
  -H "Authorization: Bearer $TOKEN")

echo "响应：$USER_RESPONSE"
echo ""

if echo "$USER_RESPONSE" | grep -q '"success":true'; then
    echo "✅ 认证接口测试通过"
else
    echo "❌ 认证接口测试失败"
fi

echo ""
echo "=== 测试完成 ==="
