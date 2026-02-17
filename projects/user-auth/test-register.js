/**
 * 用户注册测试
 */

const http = require('http');

const BASE_URL = 'http://localhost:3000';

// HTTP 请求封装
function request(method, path, data = null) {
  return new Promise((resolve, reject) => {
    const url = new URL(path, BASE_URL);
    const options = {
      hostname: url.hostname,
      port: url.port,
      path: url.pathname,
      method,
      headers: { 'Content-Type': 'application/json' }
    };
    
    const req = http.request(options, (res) => {
      let body = '';
      res.on('data', chunk => body += chunk);
      res.on('end', () => {
        try {
          resolve({ status: res.statusCode, data: JSON.parse(body) });
        } catch (e) {
          resolve({ status: res.statusCode, data: body });
        }
      });
    });
    
    req.on('error', reject);
    req.setTimeout(5000, () => {
      req.destroy();
      reject(new Error('请求超时'));
    });
    
    if (data) req.write(JSON.stringify(data));
    req.end();
  });
}

// 测试用例
const tests = [
  {
    name: '✅ 正常注册',
    data: {
      username: 'testuser',
      email: 'test@example.com',
      password: 'password123'
    },
    expect: { status: 201, success: true }
  },
  {
    name: '❌ 重复用户名',
    data: {
      username: 'testuser',
      email: 'another@example.com',
      password: 'password123'
    },
    expect: { status: 409 }
  },
  {
    name: '❌ 重复邮箱',
    data: {
      username: 'anotheruser',
      email: 'test@example.com',
      password: 'password123'
    },
    expect: { status: 409 }
  },
  {
    name: '❌ 无效邮箱',
    data: {
      username: 'validuser',
      email: 'invalid-email',
      password: 'password123'
    },
    expect: { status: 400 }
  },
  {
    name: '❌ 弱密码',
    data: {
      username: 'weakpass',
      email: 'weak@example.com',
      password: '123'
    },
    expect: { status: 400 }
  },
  {
    name: '❌ 用户名太短',
    data: {
      username: 'ab',
      email: 'short@example.com',
      password: 'password123'
    },
    expect: { status: 400 }
  }
];

// 运行测试
async function runTests() {
  console.log('🧪 开始测试用户注册 API\n');
  console.log('=' .repeat(50));
  
  let passed = 0;
  let failed = 0;
  
  for (const test of tests) {
    process.stdout.write(`\n▸ ${test.name}: `);
    
    try {
      const result = await request('POST', '/api/register', test.data);
      
      const statusOk = result.status === test.expect.status;
      const successOk = test.expect.success === undefined || 
                        result.data.success === test.expect.success;
      
      if (statusOk && successOk) {
        console.log('✅ 通过');
        passed++;
        
        if (result.data.data) {
          console.log(`  用户ID: ${result.data.data.user.id}`);
          console.log(`  Token: ${result.data.data.token.substring(0, 20)}...`);
        }
      } else {
        console.log('❌ 失败');
        console.log(`  预期状态: ${test.expect.status}, 实际: ${result.status}`);
        console.log(`  响应: ${JSON.stringify(result.data)}`);
        failed++;
      }
    } catch (error) {
      console.log('❌ 错误:', error.message);
      failed++;
    }
  }
  
  console.log('\n' + '='.repeat(50));
  console.log(`\n📊 测试结果: ${passed} 通过, ${failed} 失败\n`);
  
  // 获取所有用户
  try {
    const usersResult = await request('GET', '/api/users');
    console.log('📋 已注册用户:');
    usersResult.data.data.forEach(u => {
      console.log(`  - ${u.username} (${u.email})`);
    });
  } catch (e) {
    console.log('无法获取用户列表');
  }
  
  process.exit(failed > 0 ? 1 : 0);
}

// 检查服务器是否运行
async function checkServer() {
  try {
    await request('GET', '/api/users');
    return true;
  } catch {
    return false;
  }
}

// 主入口
(async () => {
  console.log('检查服务器状态...');
  const serverRunning = await checkServer();
  
  if (!serverRunning) {
    console.log('⚠️  服务器未运行，正在启动...\n');
    require('./server.js');
    // 等待服务器启动
    await new Promise(r => setTimeout(r, 1000));
  }
  
  await runTests();
})();
