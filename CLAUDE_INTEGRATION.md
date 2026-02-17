# CLAUDE_INTEGRATION.md

> Claude Code 本机集成配置

## 集成方式

### 方式 1: CLI 调用（推荐）

使用 coding-agent skill 直接调用 Claude Code CLI：

```bash
# 一键执行（需要 PTY 模式）
bash pty:true workdir:~/project command:"claude 'Your task here'"

# 后台执行长任务
bash pty:true workdir:~/project background:true command:"claude 'Build a REST API'"

# 自动模式（--dangerously-skip-permissions）
bash pty:true workdir:~/project command:"claude --dangerously-skip-permissions 'Refactor auth module'"
```

### 方式 2: Web UI 访问

Claude Code 本地 Web 界面：
- URL: http://localhost:4100
- 使用 browser tool 访问和交互

```bash
# 启动 Claude Code 服务（如果未运行）
claude --web

# 通过浏览器访问
browser action:open url:"http://localhost:4100"
```

## 工作流程

### 标准流程
```
1. 接收任务
   ↓
2. 分析任务复杂度
   ├─ 简单 → 直接执行
   └─ 复杂 → 调用 Claude Code
   ↓
3. Claude Code 执行
   ├─ 读取 workspace/ 上下文
   ├─ 执行编码任务
   └─ 输出结果到 workspace/
   ↓
4. 验证结果
   ├─ 代码检查
   ├─ 测试运行
   └─ 反馈用户
```

### 调用模板

```bash
# 创建任务上下文文件
echo "任务: 实现用户登录功能
要求:
- JWT 认证
- 密码加密
- 错误处理" > workspace/TASK_CONTEXT.md

# 调用 Claude Code
bash pty:true workdir:~/project background:true command:"claude 'Read workspace/TASK_CONTEXT.md and implement the feature. Write results to workspace/TASK_OUTPUT.md'"
```

## 共享上下文机制

### 输入上下文
Claude Code 可以读取以下文件：
- `workspace/TASK_CONTEXT.md` - 任务描述
- `workspace/PROJECT_INFO.md` - 项目信息
- `workspace/TEMPLATES/` - 代码模板

### 输出结果
Claude Code 处理后写入：
- `workspace/TASK_OUTPUT.md` - 执行结果
- `workspace/CODE_CHANGES.md` - 代码变更摘要
- 项目文件 - 直接修改

## 进度通知

使用 wake event 获取完成通知：

```bash
bash pty:true workdir:~/project background:true command:"claude 'Build feature X.

When done, run:
openclaw system event --text \"Done: Feature X built\" --mode now'"
```

## 常用命令速查

| 场景 | 命令 |
|-----|------|
| 快速问答 | `claude 'question'` |
| 代码生成 | `claude 'generate code for...'` |
| 代码审查 | `claude 'review src/'` |
| 重构 | `claude 'refactor module X'` |
| 调试 | `claude 'debug error: ...'` |
| 测试生成 | `claude 'write tests for...'` |

## 注意事项

1. **必须使用 PTY 模式** - Claude Code 需要终端环境
2. **设置 workdir** - 限制工作目录范围
3. **使用 background** - 长任务后台运行
4. **监控进度** - 使用 `process action:log` 查看
5. **处理输入** - 使用 `process action:submit` 回复

## 故障排除

| 问题 | 解决方案 |
|-----|---------|
| Claude Code 无响应 | 检查 PTY 模式是否启用 |
| 权限被拒绝 | 使用 `--dangerously-skip-permissions` |
| 找不到文件 | 确认 workdir 设置正确 |
| 输出乱码 | 检查终端编码设置 |

---
*最后更新: 2026-02-17*
