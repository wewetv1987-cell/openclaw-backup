# 逆向工程基础知识

> 学习日期: 2026-02-17
> 来源: OpenSecurityTraining.info - Introduction to x86

## 📚 学习概述

逆向工程（Reverse Engineering）是通过分析程序或系统来理解其工作原理的技术。在安全领域，主要用于：
- 恶意软件分析
- 漏洞挖掘
- 安全研究
- CTF 竞赛

## 🛠️ 核心技能树

### 1. 汇编语言基础 (Assembly)

#### 为什么学习汇编？
- 理解程序底层执行机制
- 分析编译后的二进制文件
- 调试和优化代码

#### 关键知识点
**寄存器 (Registers)**
- 通用寄存器: EAX, EBX, ECX, EDX (32位) / RAX, RBX, RCX, RDX (64位)
- 指针寄存器: EIP (指令指针), ESP (栈指针), EBP (基址指针)
- 段寄存器: CS, DS, SS, ES, FS, GS

**常用指令集**
```asm
# 数据传输
MOV   - 移动数据
PUSH  - 压栈
POP   - 出栈
LEA   - 加载有效地址

# 算术运算
ADD   - 加法
SUB   - 减法
MUL   - 乘法
DIV   - 除法
INC   - 自增
DEC   - 自减

# 逻辑运算
AND   - 与
OR    - 或
XOR   - 异或
NOT   - 非

# 比较与跳转
CMP   - 比较
TEST  - 测试
JMP   - 无条件跳转
JE/JZ - 相等/零时跳转
JNE/JNZ - 不等/非零跳转
JG/JL - 大于/小于跳转
CALL  - 调用函数
RET   - 返回

# 位运算
SHL/SAL - 左移
SHR     - 逻辑右移
SAR     - 算术右移

# 特殊指令
NOP     - 空操作
LEAVE   - 清理栈帧
```

**调用约定 (Calling Conventions)**
- **cdecl**: C 默认，参数从右向左压栈，调用者清理栈
- **stdcall**: Windows API，被调用者清理栈
- **fastcall**: 前几个参数通过寄存器传递

#### 栈 (Stack) 机制
```
高地址
+------------------+
|   函数参数        |
+------------------+
|   返回地址        |
+------------------+
|   保存的 EBP      |  <- EBP 指向这里
+------------------+
|   局部变量        |
+------------------+
|   ...            |  <- ESP 指向栈顶
低地址
```

### 2. 文件格式 (File Formats)

#### ELF (Linux)
- **.text**: 代码段
- **.data**: 已初始化数据
- **.bss**: 未初始化数据
- **.rodata**: 只读数据
- **.plt/.got**: 动态链接相关

#### PE (Windows)
- **.text**: 代码段
- **.data**: 数据段
- **.rdata**: 只读数据
- **.rsrc**: 资源段
- **.reloc**: 重定位表

### 3. 工具链 (Tools)

#### 静态分析工具
- **IDA Pro**: 商业软件，功能强大
- **Ghidra**: NSA 开源，免费且强大
- **radare2**: 开源命令行工具
- **Binary Ninja**: 商业软件，界面友好

#### 动态分析工具
- **GDB**: Linux 标准调试器
- **x64dbg/WinDbg**: Windows 调试器
- **LLDB**: macOS/iOS 调试器
- **Frida**: 动态插桩工具

#### 辅助工具
- **objdump**: 反汇编工具
- **readelf**: ELF 分析
- **strings**: 提取字符串
- **hexdump/xxd**: 十六进制查看
- **strace/ltrace**: 系统调用跟踪

### 4. 分析流程

#### 静态分析步骤
1. **识别文件类型**: `file` 命令
2. **查看字符串**: `strings` 命令
3. **检查安全机制**: checksec (PIE, ASLR, NX等)
4. **反汇编代码**: IDA/Ghidra
5. **理解程序逻辑**: 控制流分析
6. **识别关键函数**: API 调用、加密算法

#### 动态分析步骤
1. **环境准备**: 隔离环境、快照
2. **设置断点**: 关键位置
3. **单步执行**: 观察寄存器/内存变化
4. **监控行为**: 文件、网络、进程
5. **修改执行**: 补丁、跳过检查

## 💡 学习资源

### 入门课程
- ✅ OpenSecurityTraining2 - Intro x86
- ⏸️ Nightmare CTF 教程
- ⏸️ LiveOverflow YouTube 系列

### 实践平台
- PicoCTF (入门级)
- CTFlearn
- HackTheBox
- Crackmes.one

### 推荐书籍
- 《Professional Assembly Language》- Richard Blum
- 《Reverse Engineering for Beginners》
- 《Practical Binary Analysis》

## 🎯 实践练习

### 初级任务
- [ ] 使用 Ghidra 反汇编一个简单程序
- [ ] 理解 C 代码到汇编的对应关系
- [ ] 完成一个简单 CrackMe
- [ ] 使用 GDB 调试程序，观察栈变化

### 进阶任务
- [ ] 逆向一个带密码验证的程序
- [ ] 分析恶意样本行为
- [ ] 利用缓冲区溢出漏洞
- [ ] 绕过反调试技术

## 📊 关键概念总结

| 概念 | 说明 |
|-----|------|
| 逆向工程 | 从二进制理解源逻辑 |
| 汇编语言 | CPU 执行的底层语言 |
| 栈溢出 | 覆盖返回地址控制流程 |
| 反调试 | 检测是否被调试 |
| 混淆 | 增加逆向难度 |
| 动态链接 | 运行时加载库函数 |

## 🔍 常见安全机制

- **ASLR**: 地址空间布局随机化
- **NX/DEP**: 禁止栈执行
- **Stack Canary**: 栈保护
- **PIE**: 位置无关可执行
- **RELRO**: 只读重定位

---
*下一步: 学习 Ghidra 基本使用，完成第一个 CrackMe*
