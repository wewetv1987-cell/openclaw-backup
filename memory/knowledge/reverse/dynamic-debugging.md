# 动态调试技术

> 学习日期: 2026-02-17
> 难度: 中级
> 前置知识: x86/x64汇编、ELF/PE文件格式

---

## 📖 概述

动态调试是在程序运行时进行分析的技术，允许：
- 实时观察程序行为
- 修改内存和寄存器
- 跟踪函数调用
- 分析算法逻辑

## 🔧 主要调试工具

### 1. x64dbg (Windows)

**特点：**
- 开源免费 (GPLv3)
- 支持 x64 和 x32 应用
- 直观的图形界面
- 类似 IDA 的跳转箭头
- 智能寄存器视图
- 内存映射和符号视图
- 线程视图
- 图形视图

**核心功能：**
- 完整的 DLL/EXE 调试 (基于 TitanEngine)
- 快速反汇编器 (Zydis)
- 内置汇编器 (XEDParse/asmjit)
- 导入重构 (Scylla 集成)
- 基础 PDB 符号支持
- 动态栈视图
- 可执行文件修补
- 插件支持 (C++ API)
- 脚本语言自动化

**使用场景：**
- Windows 平台逆向
- 恶意代码分析
- 游戏逆向
- 软件破解

### 2. LLDB (macOS/Linux)

**命令结构：**
```
<noun> <verb> [-options [option-value]] [argument [argument...]]
```

**核心命令：**

#### 加载程序
```bash
# 启动时指定
lldb /path/to/executable

# 或在内部使用
(lldb) file /path/to/executable
```

#### 断点设置
```bash
# 函数断点
(lldb) breakpoint set --name foo
(lldb) breakpoint set -n foo

# 文件行号断点
(lldb) breakpoint set --file foo.c --line 12
(lldb) breakpoint set -f foo.c -l 12

# 方法断点 (C++)
(lldb) breakpoint set --method foo
(lldb) breakpoint set -M foo

# 选择器断点 (Objective-C)
(lldb) breakpoint set --selector alignLeftEdges:
(lldb) breakpoint set -S alignLeftEdges:

# 指定共享库
(lldb) breakpoint set --shlib foo.dylib --name foo
(lldb) breakpoint set -s foo.dylib -n foo

# 查看断点
(lldb) breakpoint list

# 添加断点命令
(lldb) breakpoint command add 1.1
> bt
> DONE
```

#### 断点名称 (Breakpoint Names)
```bash
# 配置断点名称
(lldb) breakpoint name configure -c "self == nil" -C bt --auto-continue SelfNil

# 应用到断点
(lldb) breakpoint set -N SelfNil

# 批量修改
(lldb) breakpoint modify -c "self == nil" -C bt --auto-continue SelfNil
```

#### 观察点 (Watchpoints)
```bash
# 设置观察点
(lldb) watch set var global
(lldb) watch modify -c '(global==5)'
(lldb) watch list
```

#### 进程控制
```bash
# 启动进程
(lldb) process launch
(lldb) run
(lldb) r

# 附加到进程
(lldb) process attach --pid 123
(lldb) process attach --name Sketch
(lldb) process attach --name Sketch --waitfor

# 继续执行
(lldb) thread continue
(lldb) c

# 单步执行
(lldb) thread step-in      # step (s)
(lldb) thread step-over    # next (n)
(lldb) thread step-out     # finish (f)

# 指令级单步
(lldb) thread step-inst           # stepi (si)
(lldb) thread step-over-inst      # nexti (ni)

# 运行到指定行
(lldb) thread until 100
```

#### 查看线程状态
```bash
# 列出线程
(lldb) thread list

# 查看调用栈
(lldb) thread backtrace
(lldb) thread backtrace all

# 选择线程
(lldb) thread select 2
```

#### 查看栈帧状态
```bash
# 查看局部变量
(lldb) frame variable
(lldb) frame variable self
(lldb) frame variable self.isa
(lldb) frame variable *self
(lldb) frame variable &self
(lldb) frame variable argv[0]

# 对象打印 (Objective-C)
(lldb) frame variable -o self

# 选择栈帧
(lldb) frame select 9
(lldb) frame select --relative 1  # 上移
(lldb) frame select --relative -1 # 下移
```

**特殊功能：**
- 命令别名系统
- Python 脚本支持
- 自动补全 (TAB)
- 配置文件 (~/.lldbinit)
- 操作栈管理 (可中断的步进操作)

## 🎯 调试技术要点

### 断点类型
1. **软件断点** - 替换指令为 INT 3 (0xCC)
2. **硬件断点** - 使用调试寄存器 (DR0-DR3)
3. **内存断点** - 监控内存访问/写入
4. **条件断点** - 满足条件时触发

### 常见调试场景

#### 1. 跟踪函数调用
```
- 在目标函数设置断点
- 查看参数传递 (寄存器/栈)
- 单步执行观察逻辑
- 记录返回值
```

#### 2. 分析算法
```
- 在关键位置设置断点
- 观察输入输出
- 跟踪数据变换
- 记录中间结果
```

#### 3. 绕过验证
```
- 定位验证函数
- 设置条件断点
- 修改比较结果
- 跳过检查逻辑
```

#### 4. 查找关键数据
```
- 使用观察点监控变量
- 跟踪数据引用
- 定位数据结构
- 分析数据处理流程
```

## 💡 最佳实践

### 1. 断点管理
- 使用断点名称组织断点
- 设置条件避免频繁中断
- 为断点添加自动命令
- 合理使用硬件/软件断点

### 2. 效率提升
- 创建常用命令别名
- 编写自动化脚本
- 使用图形视图辅助理解
- 保存工作区配置

### 3. 多线程调试
- 关注线程同步问题
- 使用线程过滤功能
- 注意竞态条件
- 记录线程状态变化

### 4. 调试技巧
- 先静态分析再动态调试
- 结合反汇编代码理解
- 记录重要地址和偏移
- 保存补丁和修改

## ⚠️ 反调试检测

常见反调试技术：
- IsDebuggerPresent() (Windows)
- ptrace 限制 (Linux)
- 时间检测
- 异常处理检测
- 父进程检测
- 窗口名检测
- 调试寄存器检测

绕过方法：
- 补丁检测代码
- 使用插件自动绕过
- 修改返回值
- 隐藏调试器特征

## 📚 进阶主题

### 1. 脚本自动化
- x64dbg: 脚本语言、插件开发
- LLDB: Python API、命令别名

### 2. 远程调试
- 网络调试协议
- 虚拟机调试
- 内核调试

### 3. 内存分析
- 堆栈跟踪
- 内存泄漏检测
- 数据结构重建

### 4. 混合调试
- 源码级调试
- 汇编级调试
- JIT 调试

---

## 📝 学习检查清单

- [ ] 掌握 x64dbg 基本操作
- [ ] 掌握 LLDB 基本命令
- [ ] 理解断点类型和设置
- [ ] 能够单步调试程序
- [ ] 能够查看内存和寄存器
- [ ] 理解调用栈概念
- [ ] 能够使用条件断点
- [ ] 了解反调试技术
- [ ] 能够编写简单调试脚本

---

## 🔗 相关资源

- [x64dbg 官网](https://x64dbg.com/)
- [LLDB 官方文档](https://lldb.llvm.org/)
- [x64dbg 插件仓库](https://github.com/x64dbg)
- [LLDB Python API](https://lldb.llvm.org/python_api.html)

---

*下一步学习: 静态分析工具 (IDA Pro, radare2)*
