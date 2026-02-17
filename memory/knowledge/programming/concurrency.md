# 并发编程 - Node.js 与 Python

> 学习日期: 2026-02-17
> 领域: 编程 - 后端基础
> 状态: 已完成基础学习

## 📖 核心概念

### 并发 vs 并行

| 概念 | 定义 | 适用场景 |
|------|------|----------|
| **并行 (Parallelism)** | 同时执行多个操作 | CPU 密集型任务 |
| **并发 (Concurrency)** | 任务交替执行，给人同时进行的错觉 | I/O 密集型任务 |
| **异步 I/O** | 单线程内实现并发 | 网络请求、文件操作 |

### 为什么需要异步？

**同步问题示例**（以国际象棋大师表演赛为例）：
- 同步模式：24 场比赛 × 30 分钟 = 12 小时
- 异步模式：轮流走棋，总计仅需 1 小时
- **性能提升：12 倍**

---

## 🐍 Python asyncio

### 基础语法

```python
import asyncio

# 定义协程
async def count():
    print("One")
    await asyncio.sleep(1)
    print("Two")

# 主协程
async def main():
    # 并发运行多个协程
    await asyncio.gather(count(), count(), count())

# 启动事件循环
asyncio.run(main())
```

**执行结果**：
- 同步版本：约 6 秒
- 异步版本：约 2 秒

### 关键要点

#### 1. async/await 规则
```python
# ✅ 正确
async def my_function():
    result = await some_async_operation()
    return result

# ❌ 错误 - await 不能在普通函数中使用
def regular_function():
    await something()  # SyntaxError!

# ❌ 错误 - async def 不能使用 yield from
async def bad():
    yield from something()  # SyntaxError!
```

#### 2. 事件循环 (Event Loop)
```python
# 推荐方式
asyncio.run(main())

# 获取运行中的循环
loop = asyncio.get_running_loop()
```

**事件循环特性**：
- 默认单线程、单进程
- 通过协作式多任务实现并发
- 可插拔实现（可使用 uvloop 提升性能）

#### 3. 高级 API

```python
# 并发运行多个协程
results = await asyncio.gather(
    fetch_url(url1),
    fetch_url(url2),
    fetch_url(url3)
)

# 创建任务
task = asyncio.create_task(some_coroutine())

# 队列
queue = asyncio.Queue()
await queue.put(item)
item = await queue.get()

# 同步原语
lock = asyncio.Lock()
async with lock:
    # 临界区
    pass
```

### 性能对比

| 场景 | 同步耗时 | 异步耗时 | 提升 |
|------|----------|----------|------|
| 3 次网络请求（各 1 秒） | 3 秒 | 1 秒 | 3x |
| 24 个 I/O 操作（各 1 秒） | 24 秒 | 1 秒 | 24x |

### 使用场景判断

✅ **适合 asyncio**：
- 大量网络请求（API 调用、爬虫）
- 数据库查询
- 文件 I/O 操作
- 等待用户输入

❌ **不适合 asyncio**：
- CPU 密集型计算
- 紧密的 for 循环
- 数学计算

---

## 💻 JavaScript / Node.js

### async/await 语法

```javascript
// async 函数总是返回 Promise
async function f() {
    return 1;
}

f().then(alert); // 1

// await 暂停执行直到 Promise 解决
async function fetchUser() {
    let response = await fetch('/api/user.json');
    let user = await response.json();
    return user;
}
```

### 错误处理

```javascript
// try-catch 方式
async function fetchData() {
    try {
        let response = await fetch('http://example.com');
        let data = await response.json();
        return data;
    } catch (error) {
        console.error('请求失败:', error);
        throw error;
    }
}

// .catch 方式（顶层使用）
fetchData()
    .then(data => console.log(data))
    .catch(error => console.error(error));
```

### 并行执行

```javascript
// Promise.all 并行等待多个 Promise
async function fetchMultiple() {
    let results = await Promise.all([
        fetch(url1),
        fetch(url2),
        fetch(url3)
    ]);
    return results;
}
```

### 浏览器中的顶级 await

```javascript
// ✅ 模块中支持顶级 await
let response = await fetch('/api/data.json');
let data = await response.json();

// ❌ 普通脚本中不支持
// 解决方案：包装到 async IIFE
(async () => {
    let data = await fetchData();
    console.log(data);
})();
```

---

## 🔄 对比总结

| 特性 | Python asyncio | JavaScript async/await |
|------|----------------|------------------------|
| **关键字** | async def, await | async function, await |
| **入口点** | asyncio.run() | 直接调用 |
| **并行执行** | asyncio.gather() | Promise.all() |
| **事件循环** | 需要显式管理 | 自动管理（浏览器/Node.js） |
| **错误处理** | try/except | try/catch |
| **适用场景** | I/O 密集型 | I/O 密集型、前端交互 |

---

## ⚠️ 常见陷阱

### Python

1. **忘记 await**
```python
# ❌ 协程不会执行
async def bad():
    asyncio.sleep(1)  # 忘记 await

# ✅ 正确
async def good():
    await asyncio.sleep(1)
```

2. **使用阻塞调用**
```python
# ❌ 阻塞事件循环
async def bad():
    time.sleep(5)  # 阻塞！

# ✅ 使用异步版本
async def good():
    await asyncio.sleep(5)
```

### JavaScript

1. **忘记 async**
```javascript
// ❌ SyntaxError
function bad() {
    await fetch(url);  // 必须在 async 函数中
}

// ✅ 正确
async function good() {
    await fetch(url);
}
```

2. **串行 vs 并行**
```javascript
// ❌ 串行执行（慢）
let a = await fetch(url1);
let b = await fetch(url2);

// ✅ 并行执行（快）
let [a, b] = await Promise.all([
    fetch(url1),
    fetch(url2)
]);
```

---

## 🎯 最佳实践

### 1. 选择正确的并发模型

```
CPU 密集型 → multiprocessing（Python） / Worker Threads（Node.js）
I/O 密集型 → asyncio（Python） / async/await（Node.js）
```

### 2. 代码组织

```python
# 拆分为小组件
async def fetch_data(url):
    response = await fetch(url)
    return await response.json()

async def process_data(data):
    # 处理逻辑
    pass

async def main():
    data = await fetch_data('https://api.example.com')
    result = await process_data(data)
    return result
```

### 3. 错误处理策略

- 内层：使用 try/except（或 try/catch）处理预期错误
- 外层：使用 .catch() 捕获未处理错误
- 全局：设置 unhandledRejection 监听器

---

## 📚 参考资源

- [Python asyncio 官方文档](https://docs.python.org/3/library/asyncio.html)
- [Real Python - asyncio 教程](https://realpython.com/async-io-python/)
- [MDN - 异步 JavaScript](https://developer.mozilla.org/en-US/docs/Learn/JavaScript/Asynchronous)
- [JavaScript.info - async/await](https://javascript.info/async-await)

---

## 📝 学习检查点

- [x] 理解并发与并行的区别
- [x] 掌握 Python async/await 语法
- [x] 掌握 JavaScript async/await 语法
- [x] 了解事件循环机制
- [x] 理解何时使用异步编程
- [x] 掌握错误处理方法
- [ ] 实践：编写异步爬虫
- [ ] 实践：实现并发 API 客户端

---

*创建时间: 2026-02-17 12:00*
*来源: 空闲自动学习任务*
