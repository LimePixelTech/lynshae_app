#!/usr/bin/env node
/**
 * LynShae 前后端通信测试脚本
 * 验证 API 服务是否正常工作
 */

const http = require('http');

const API_BASE = 'http://localhost:3005/api/v1';

// 颜色输出
const colors = {
  reset: '\x1b[0m',
  green: '\x1b[32m',
  red: '\x1b[31m',
  yellow: '\x1b[33m',
  blue: '\x1b[34m'
};

function log(color, message) {
  console.log(`${color}${message}${colors.reset}`);
}

// HTTP 请求封装
function request(path, method = 'GET', body = null, token = null) {
  return new Promise((resolve, reject) => {
    const url = new URL(path, API_BASE);
    const options = {
      hostname: url.hostname,
      port: url.port,
      path: url.pathname + url.search,
      method: method,
      headers: {
        'Content-Type': 'application/json'
      }
    };

    if (token) {
      options.headers['Authorization'] = `Bearer ${token}`;
    }

    const req = http.request(options, (res) => {
      let data = '';
      res.on('data', chunk => data += chunk);
      res.on('end', () => {
        try {
          resolve({
            status: res.statusCode,
            data: JSON.parse(data)
          });
        } catch (e) {
          resolve({
            status: res.statusCode,
            data: data
          });
        }
      });
    });

    req.on('error', reject);

    if (body) {
      req.write(JSON.stringify(body));
    }

    req.end();
  });
}

// 测试健康检查
async function testHealth() {
  log(colors.blue, '\n📊 测试 1: 健康检查');
  const res = await request('/health');
  if (res.status === 200 && res.data.status === 'ok') {
    log(colors.green, '✅ 健康检查通过');
    return true;
  } else {
    log(colors.red, `❌ 健康检查失败：${res.status}`);
    return false;
  }
}

// 测试 API 文档
async function testDocs() {
  log(colors.blue, '\n📚 测试 2: API 文档');
  const res = await request('/docs');
  if (res.status === 200 && res.data.name === 'LynShae API') {
    log(colors.green, '✅ API 文档可访问');
    log(colors.yellow, `   版本：${res.data.version}`);
    log(colors.yellow, `   端点：${Object.keys(res.data.endpoints).length} 个`);
    return true;
  } else {
    log(colors.red, `❌ API 文档访问失败`);
    return false;
  }
}

// 测试登录
async function testLogin() {
  log(colors.blue, '\n🔐 测试 3: 用户登录');
  const res = await request('/auth/login', 'POST', {
    email: 'admin@lynshae.com',
    password: 'admin123'
  });
  
  if (res.status === 200 && res.data.token) {
    log(colors.green, '✅ 登录成功');
    log(colors.yellow, `   用户：${res.data.user?.email || 'N/A'}`);
    log(colors.yellow, `   Token: ${res.data.token.substring(0, 20)}...`);
    return res.data.token;
  } else {
    log(colors.red, `❌ 登录失败：${res.status}`);
    log(colors.yellow, `   响应：${JSON.stringify(res.data).substring(0, 100)}`);
    return null;
  }
}

// 测试获取商品列表
async function testGetProducts(token) {
  log(colors.blue, '\n🛍️ 测试 4: 获取商品列表');
  const res = await request('/products', 'GET', null, token);
  if (res.status === 200) {
    log(colors.green, '✅ 商品列表获取成功');
    if (res.data.products) {
      log(colors.yellow, `   商品数量：${res.data.products.length}`);
    }
    return true;
  } else {
    log(colors.red, `❌ 商品列表获取失败：${res.status}`);
    return false;
  }
}

// 测试获取分类列表
async function testGetCategories(token) {
  log(colors.blue, '\n📁 测试 5: 获取分类列表');
  const res = await request('/categories', 'GET', null, token);
  if (res.status === 200) {
    log(colors.green, '✅ 分类列表获取成功');
    if (res.data.categories) {
      log(colors.yellow, `   分类数量：${res.data.categories.length}`);
    }
    return true;
  } else {
    log(colors.red, `❌ 分类列表获取失败：${res.status}`);
    return false;
  }
}

// 测试管理后台 API（需要认证）
async function testAdminProducts(token) {
  log(colors.blue, '\n🔧 测试 6: 管理后台商品 API');
  if (!token) {
    log(colors.yellow, '⏭️  跳过（无 Token）');
    return true;
  }
  
  const res = await request('/products/admin/list', 'GET', null, token);
  if (res.status === 200) {
    log(colors.green, '✅ 管理后台商品 API 可访问');
    return true;
  } else {
    log(colors.red, `❌ 管理后台商品 API 访问失败：${res.status}`);
    return false;
  }
}

// 主测试流程
async function main() {
  log(colors.blue, '\n========================================');
  log(colors.blue, '  LynShae 前后端通信测试');
  log(colors.blue, '========================================\n');
  
  const results = [];
  
  // 测试 1: 健康检查
  results.push(await testHealth());
  
  // 测试 2: API 文档
  results.push(await testDocs());
  
  // 测试 3: 登录
  const token = await testLogin();
  results.push(!!token);
  
  if (token) {
    // 测试 4: 获取商品
    results.push(await testGetProducts(token));
    
    // 测试 5: 获取分类
    results.push(await testGetCategories(token));
    
    // 测试 6: 管理后台 API
    results.push(await testAdminProducts(token));
  }
  
  // 总结
  log(colors.blue, '\n========================================');
  log(colors.blue, '  测试结果');
  log(colors.blue, '========================================\n');
  
  const passed = results.filter(r => r).length;
  const total = results.length;
  
  if (passed === total) {
    log(colors.green, `✅ 所有测试通过 (${passed}/${total})`);
    process.exit(0);
  } else {
    log(colors.red, `❌ ${total - passed} 个测试失败 (${passed}/${total})`);
    process.exit(1);
  }
}

// 运行测试
main().catch(err => {
  log(colors.red, `\n❌ 测试执行失败：${err.message}`);
  process.exit(1);
});
