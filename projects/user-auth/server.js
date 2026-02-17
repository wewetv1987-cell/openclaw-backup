/**
 * 用户注册系统 - 主服务
 */

const express = require('express');
const bcrypt = require('bcryptjs');
const { v4: uuidv4 } = require('uuid');

const app = express();
app.use(express.json());

// 模拟数据库
const users = new Map();

// 验证函数
const validators = {
  username: (value) => {
    if (!value || value.length < 3 || value.length > 20) {
      return '用户名需要 3-20 个字符';
    }
    if (!/^[a-zA-Z0-9_]+$/.test(value)) {
      return '用户名只能包含字母、数字和下划线';
    }
    return null;
  },
  
  email: (value) => {
    if (!value) return '邮箱不能为空';
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!emailRegex.test(value)) {
      return '邮箱格式无效';
    }
    return null;
  },
  
  password: (value) => {
    if (!value || value.length < 8) {
      return '密码至少需要 8 个字符';
    }
    return null;
  }
};

// 检查用户名/邮箱是否已存在
const checkExists = (username, email) => {
  for (const user of users.values()) {
    if (user.username === username) {
      return { field: 'username', message: '用户名已存在' };
    }
    if (user.email === email) {
      return { field: 'email', message: '邮箱已被注册' };
    }
  }
  return null;
};

// 生成简单 token
const generateToken = (userId) => {
  return Buffer.from(`${userId}:${Date.now()}`).toString('base64');
};

/**
 * POST /api/register
 * 用户注册接口
 */
app.post('/api/register', async (req, res) => {
  try {
    const { username, email, password } = req.body;
    
    // 验证输入
    const errors = [];
    
    const usernameError = validators.username(username);
    if (usernameError) errors.push({ field: 'username', message: usernameError });
    
    const emailError = validators.email(email);
    if (emailError) errors.push({ field: 'email', message: emailError });
    
    const passwordError = validators.password(password);
    if (passwordError) errors.push({ field: 'password', message: passwordError });
    
    if (errors.length > 0) {
      return res.status(400).json({
        success: false,
        error: '验证失败',
        errors
      });
    }
    
    // 检查是否已存在
    const existsError = checkExists(username, email);
    if (existsError) {
      return res.status(409).json({
        success: false,
        error: existsError.message,
        field: existsError.field
      });
    }
    
    // 加密密码
    const passwordHash = await bcrypt.hash(password, 10);
    
    // 创建用户
    const userId = uuidv4();
    const user = {
      id: userId,
      username,
      email,
      passwordHash,
      createdAt: new Date().toISOString()
    };
    
    users.set(userId, user);
    
    // 生成 token
    const token = generateToken(userId);
    
    // 返回成功
    res.status(201).json({
      success: true,
      message: '注册成功',
      data: {
        user: {
          id: user.id,
          username: user.username,
          email: user.email,
          createdAt: user.createdAt
        },
        token
      }
    });
    
  } catch (error) {
    console.error('注册错误:', error);
    res.status(500).json({
      success: false,
      error: '服务器内部错误'
    });
  }
});

/**
 * GET /api/users
 * 获取所有用户（测试用）
 */
app.get('/api/users', (req, res) => {
  const userList = Array.from(users.values()).map(u => ({
    id: u.id,
    username: u.username,
    email: u.email,
    createdAt: u.createdAt
  }));
  
  res.json({
    success: true,
    count: userList.length,
    data: userList
  });
});

// 启动服务器
const PORT = process.env.PORT || 3000;

if (require.main === module) {
  app.listen(PORT, () => {
    console.log(`🚀 用户注册服务运行在 http://localhost:${PORT}`);
    console.log(`📝 注册接口: POST http://localhost:${PORT}/api/register`);
  });
}

module.exports = { app, users, validators };
