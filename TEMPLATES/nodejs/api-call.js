/**
 * API 调用模板
 * 支持 REST API 调用、重试、错误处理
 */

const axios = require('axios');

// 配置
const config = {
    baseUrl: process.env.API_BASE_URL || 'https://api.example.com',
    timeout: 30000,
    retries: 3,
    retryDelay: 1000,
};

// 创建 axios 实例
const client = axios.create({
    baseURL: config.baseUrl,
    timeout: config.timeout,
    headers: {
        'Content-Type': 'application/json',
    },
});

// 请求拦截器
client.interceptors.request.use(
    (config) => {
        // 添加认证头
        const token = process.env.API_TOKEN;
        if (token) {
            config.headers.Authorization = `Bearer ${token}`;
        }
        console.log(`📤 ${config.method?.toUpperCase()} ${config.url}`);
        return config;
    },
    (error) => Promise.reject(error)
);

// 响应拦截器
client.interceptors.response.use(
    (response) => {
        console.log(`📥 ${response.status} ${response.config.url}`);
        return response.data;
    },
    (error) => {
        console.error(`❌ ${error.message}`);
        return Promise.reject(error);
    }
);

// 重试包装器
async function withRetry(fn, retries = config.retries) {
    for (let i = 0; i < retries; i++) {
        try {
            return await fn();
        } catch (error) {
            if (i === retries - 1) throw error;
            console.log(`🔄 重试 ${i + 1}/${retries}...`);
            await new Promise(r => setTimeout(r, config.retryDelay * (i + 1)));
        }
    }
}

// API 方法
const api = {
    get: (path, params) => withRetry(() => client.get(path, { params })),
    post: (path, data) => withRetry(() => client.post(path, data)),
    put: (path, data) => withRetry(() => client.put(path, data)),
    delete: (path) => withRetry(() => client.delete(path)),
};

// 使用示例
async function main() {
    try {
        // GET 请求
        const users = await api.get('/users', { limit: 10 });
        console.log('用户列表:', users);

        // POST 请求
        const newUser = await api.post('/users', {
            name: 'Test User',
            email: 'test@example.com',
        });
        console.log('创建用户:', newUser);

    } catch (error) {
        console.error('API 调用失败:', error.message);
        process.exit(1);
    }
}

module.exports = { api, client, withRetry };

// 如果直接运行
if (require.main === module) {
    main();
}
