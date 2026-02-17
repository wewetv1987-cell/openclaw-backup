# AI 代码生成最佳实践

> 学习时间：2026-02-17 06:00
> 来源：自主学习整理

## 🎯 核心原则

### 1. 清晰的上下文提供
```markdown
❌ 差的提示：
"写一个登录功能"

✅ 好的提示：
"使用 Node.js + Express + JWT 创建用户登录 API：
- 密码使用 bcrypt 加密
- 返回有效期为 7 天的 JWT token
- 包含输入验证（邮箱格式、密码强度）
- 错误处理和日志记录"
```

### 2. 迭代式开发
- **第一轮**：生成基础功能
- **第二轮**：添加错误处理
- **第三轮**：优化性能
- **第四轮**：添加测试

### 3. 分层架构思维
```
表现层 (API/UI) → 业务逻辑层 → 数据访问层 → 数据库
```

## 📝 Prompt 模板

### 功能开发模板
```markdown
## 任务
[清晰描述功能需求]

## 技术栈
- 语言：[Python/JavaScript/Go]
- 框架：[Django/Express/Gin]
- 数据库：[PostgreSQL/MongoDB]

## 要求
1. [具体要求1]
2. [具体要求2]

## 输出格式
- [ ] 代码实现
- [ ] 单元测试
- [ ] API 文档
```

### 调试模板
```markdown
## 问题描述
[错误现象]

## 当前代码
```[language]
[代码片段]
```

## 错误信息
[完整错误堆栈]

## 预期行为
[应该如何工作]
```

## 🔧 常见模式

### 1. 渐进式细化
```
第一步："创建 REST API 骨架"
第二步："添加用户 CRUD 操作"
第三步："实现认证中间件"
第四步："添加速率限制"
```

### 2. 上下文注入
```javascript
// 在代码中添加上下文注释
/**
 * Context: E-commerce payment processing
 * Requirements:
 * - Support multiple payment methods
 * - Handle transaction failures
 * - Generate receipts
 */
function processPayment(order, method) {
  // AI 会基于上下文生成更准确的代码
}
```

### 3. 约束驱动
```markdown
生成代码时请遵循：
- 函数不超过 30 行
- 单一职责原则
- 依赖注入
- 不可变数据结构
- 纯函数优先
```

## 🚫 常见陷阱

### 1. 过度信任生成的代码
```python
# ❌ 直接使用
code = ai.generate("查询数据库")
exec(code)

# ✅ 审查后使用
code = ai.generate("查询数据库")
review_code(code)  # 检查 SQL 注入、性能等
test_code(code)    # 单元测试
```

### 2. 忽略边界条件
```javascript
// AI 可能忘记处理
function getUser(id) {
  return users.find(u => u.id === id); // 如果找不到？
}

// 需要明确要求
function getUser(id) {
  const user = users.find(u => u.id === id);
  if (!user) {
    throw new NotFoundError(`User ${id} not found`);
  }
  return user;
}
```

### 3. 缺少类型安全
```typescript
// ❌ 隐式 any
function process(data) {
  return data.value;
}

// ✅ 明确类型
interface UserData {
  id: string;
  value: number;
}

function process(data: UserData): number {
  return data.value;
}
```

## 💡 优化技巧

### 1. Few-Shot Learning
```markdown
示例1：
输入："计算平均值"
输出：
```python
def average(numbers: List[float]) -> float:
    if not numbers:
        raise ValueError("Empty list")
    return sum(numbers) / len(numbers)
```

示例2：
输入："查找最大值"
输出：
```python
def find_max(numbers: List[float]) -> float:
    if not numbers:
        raise ValueError("Empty list")
    return max(numbers)
```

现在生成："计算中位数"
```

### 2. 角色扮演
```markdown
你是一位拥有10年经验的后端架构师，专精于：
- 微服务设计
- 高并发系统
- 分布式事务

请设计一个订单系统的数据库架构...
```

### 3. 验证驱动开发
```markdown
先写测试用例：
```python
def test_user_registration():
    # 正常注册
    user = register("test@example.com", "Secure123!")
    assert user.email == "test@example.com"
    
    # 重复邮箱
    with pytest.raises(DuplicateError):
        register("test@example.com", "Another123!")
    
    # 弱密码
    with pytest.raises(WeakPasswordError):
        register("new@example.com", "123")
```

现在实现 register 函数通过这些测试
```

## 🎓 学习检查清单

- [x] 理解清晰的上下文提供
- [x] 掌握迭代式开发流程
- [x] 学会分层架构应用
- [x] 能够使用 Prompt 模板
- [x] 了解常见陷阱和避免方法
- [x] 掌握 Few-Shot Learning
- [x] 理解角色扮演技巧
- [x] 掌握验证驱动开发

## 📚 延伸学习

1. **代码审查技巧**
   - 识别生成代码的安全漏洞
   - 性能问题检测
   - 代码规范检查

2. **领域特定语言 (DSL)**
   - 为特定领域创建 Prompt 模板
   - 构建可复用的代码生成库

3. **持续集成**
   - 将 AI 代码生成集成到 CI/CD
   - 自动化测试和质量检查

## 🔗 相关资源

- memory/knowledge/vibe-coding/basics.md - Vibe Coding 基础
- memory/knowledge/vibe-coding/prompts.md - Prompt 优化技巧
- LEARNING_SYSTEM.md - 学习系统总览

---
*最后更新：2026-02-17 06:00*
