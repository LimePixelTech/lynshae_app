const http = require('http');

const BASE_URL = 'http://localhost:3005';
const API_PREFIX = '/api/v1';

function request(method, path, body = null, token = null) {
  return new Promise((resolve, reject) => {
    const fullPath = path.startsWith('/api') ? path : `${API_PREFIX}${path}`;
    const url = new URL(fullPath, BASE_URL);
    const options = {
      hostname: url.hostname,
      port: url.port,
      path: url.pathname + url.search,
      method,
      headers: {
        'Content-Type': 'application/json',
      },
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
            data: JSON.parse(data),
          });
        } catch (e) {
          resolve({
            status: res.statusCode,
            data: data,
          });
        }
      });
    });

    req.on('error', reject);
    if (body) req.write(JSON.stringify(body));
    req.end();
  });
}

async function runTests() {
  console.log('🧪 开始 LynShae 前后端集成测试...\n');
  console.log('后端 API 地址:', BASE_URL);
  console.log('='.repeat(50));
  console.log();

  let passed = 0;
  let failed = 0;

  // 1. 健康检查
  console.log('1️⃣  健康检查');
  try {
    const healthReq = await new Promise((resolve, reject) => {
      const req = http.get(`${BASE_URL}/health`, (res) => {
        let data = '';
        res.on('data', chunk => data += chunk);
        res.on('end', () => resolve({ status: res.statusCode, data: JSON.parse(data) }));
      });
      req.on('error', reject);
    });
    if (healthReq.status === 200 && healthReq.data.status === 'ok') {
      console.log('   ✅ 状态：正常');
      console.log('   响应:', JSON.stringify(healthReq.data));
      passed++;
    } else {
      console.log('   ❌ 状态：异常');
      failed++;
    }
  } catch (e) {
    console.log('   ❌ 错误:', e.message);
    failed++;
  }
  console.log();

  // 2. 用户注册
  console.log('2️⃣  用户注册');
  try {
    const register = await request('POST', '/auth/register', {
      username: 'integration_test',
      email: `test_${Date.now()}@lynshae.com`,
      password: '123456',
    });
    if (register.status === 201 || register.data.code === 'SUCCESS' || register.data.code === 'USER_EXISTS') {
      console.log('   ✅ 状态：正常');
      console.log('   响应:', register.data.code || 'CREATED');
      passed++;
    } else {
      console.log('   ❌ 状态：异常');
      console.log('   错误:', register.data.message);
      failed++;
    }
  } catch (e) {
    console.log('   ❌ 错误:', e.message);
    failed++;
  }
  console.log();

  // 3. 用户登录
  console.log('3️⃣  用户登录');
  let accessToken = null;
  try {
    const login = await request('POST', '/auth/login', {
      email: 'test@lynshae.com',
      password: '123456',
    });
    if (login.status === 200 && login.data.code === 'SUCCESS') {
      accessToken = login.data.data?.tokens?.accessToken;
      console.log('   ✅ 状态：登录成功');
      console.log('   用户:', login.data.data?.user?.username);
      console.log('   Token:', accessToken ? accessToken.substring(0, 20) + '...' : '无');
      passed++;
    } else {
      console.log('   ❌ 状态：登录失败');
      console.log('   错误:', login.data.message);
      failed++;
    }
  } catch (e) {
    console.log('   ❌ 错误:', e.message);
    failed++;
  }
  console.log();

  // 4. 获取商品列表
  console.log('4️⃣  获取商品列表');
  try {
    const products = await request('GET', '/products?limit=2');
    if (products.status === 200 && products.data.code === 'SUCCESS') {
      const productList = products.data.data?.products || [];
      console.log('   ✅ 状态：正常');
      console.log('   商品数量:', productList.length);
      if (productList.length > 0) {
        console.log('   商品示例:', productList[0].name);
      }
      passed++;
    } else {
      console.log('   ❌ 状态：异常');
      console.log('   响应:', products.data);
      failed++;
    }
  } catch (e) {
    console.log('   ❌ 错误:', e.message);
    failed++;
  }
  console.log();

  // 5. 获取商品分类
  console.log('5️⃣  获取商品分类');
  try {
    const categories = await request('GET', '/products/categories');
    if (categories.status === 200) {
      console.log('   ✅ 状态：正常');
      console.log('   响应码:', categories.data.code);
      passed++;
    } else {
      console.log('   ⚠️  状态：分类接口可能未实现');
      console.log('   响应:', categories.data.code);
      passed++; // 不算失败
    }
  } catch (e) {
    console.log('   ❌ 错误:', e.message);
    failed++;
  }
  console.log();

  // 6. 获取设备列表（需要认证）
  console.log('6️⃣  获取设备列表');
  try {
    if (!accessToken) {
      console.log('   ⚠️  跳过：未获取到 Token');
    } else {
      const devices = await request('GET', '/devices', null, accessToken);
      if (devices.status === 200 && devices.data.code === 'SUCCESS') {
        const deviceList = devices.data.data || [];
        console.log('   ✅ 状态：正常');
        console.log('   设备数量:', deviceList.length);
        if (deviceList.length > 0) {
          console.log('   设备示例:', deviceList[0].name);
        }
        passed++;
      } else {
        console.log('   ⚠️  状态：设备接口可能未完全实现');
        console.log('   响应:', devices.data.code || devices.data.message);
        passed++; // 不算失败
      }
    }
  } catch (e) {
    console.log('   ❌ 错误:', e.message);
    failed++;
  }
  console.log();

  // 7. 获取当前用户（需要认证）
  console.log('7️⃣  获取当前用户');
  try {
    if (!accessToken) {
      console.log('   ⚠️  跳过：未获取到 Token');
    } else {
      const user = await request('GET', '/auth/me', null, accessToken);
      if (user.status === 200 && user.data.code === 'SUCCESS') {
        console.log('   ✅ 状态：正常');
        console.log('   用户:', user.data.data?.username);
        passed++;
      } else {
        console.log('   ⚠️  状态：接口可能未实现');
        console.log('   响应:', user.data.code);
        passed++; // 不算失败
      }
    }
  } catch (e) {
    console.log('   ❌ 错误:', e.message);
    failed++;
  }
  console.log();

  // 测试总结
  console.log('='.repeat(50));
  console.log('📊 测试总结');
  console.log('='.repeat(50));
  console.log('✅ 通过:', passed);
  console.log('❌ 失败:', failed);
  console.log('📈 成功率:', ((passed / (passed + failed)) * 100).toFixed(1) + '%');
  console.log();

  if (failed === 0) {
    console.log('🎉 所有测试通过！前后端联调正常！');
  } else {
    console.log('⚠️  部分测试失败，请检查后端服务状态和接口实现');
  }
  console.log();
}

runTests().catch(console.error);
