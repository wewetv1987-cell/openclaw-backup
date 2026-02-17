# Ghidra 基础教程

> 学习日期：2026-02-17
> 来源：Ghidra 官方文档 (ghidra.re)

## 📌 概述

Ghidra 是由 NSA 开发的免费开源逆向工程框架，用 Java 编写，跨平台支持。

### 核心特性
- **集成开发环境 (IDE)**：专为逆向工程任务设计
- **跨平台**：支持 Windows、Linux、macOS
- **高度可扩展**：通过插件系统扩展功能
- **团队协作**：支持多人协作分析同一程序
- **撤销功能**：支持操作撤销，便于实验

## 🏗️ 架构组成

### 五大核心组件

#### 1. Programs（程序）
- 所有数据存储在 Ghidra 自定义数据库中
- 用户添加的数据也存入数据库：
  - 符号 (Symbols)
  - 字节 (Bytes)
  - 引用 (References)
  - 指令 (Instructions)
  - 数据 (Data)
  - 注释 (Comments)

#### 2. Plugins（插件）
- Ghidra 是插件库集合
- 每个插件提供特定功能
- 插件间在工具内相互通信
- 可动态添加/移除插件（无需重启）
- 用户可编写自定义插件

#### 3. Tools（工具）
- 插件及其配置的集合
- 预配置工具可自定义
- 可创建新工具（添加插件到空工具）
- 工具配置自动保存

#### 4. Project Manager（项目管理器）
- 管理项目、工具和数据
- 程序必须导入项目才能工作
- 项目配置自动保存

#### 5. Ghidra Server（服务器）
- 支持多用户共享项目数据
- 提供网络存储
- 控制用户访问
- 支持版本控制（检出/检入/历史）

## 🚀 安装与启动

### 系统要求
- Windows 10+ (64-bit)
- Linux (64-bit)
- macOS 10.13+

### 安装步骤
1. 解压安装文件：`ghidra_<version>_<release>_<date>.zip`
2. 运行启动脚本：
   - Windows: `ghidraRun.bat`
   - Linux/macOS: `ghidraRun.sh`

### 首次运行
- 可能需要指定 Java 路径
- 首次启动较慢（搜索插件）
- 显示空项目窗口

## 📁 项目管理

### 创建新项目
1. File → New Project
2. 选择项目类型：
   - **Non-Shared**：个人项目
   - **Shared**：团队项目（需服务器）
3. 选择项目目录（建议本地驱动器）
4. 输入项目名称

### 项目管理器功能
- 创建、打开、归档项目
- 导入程序
- 在工具中打开程序
- 创建子文件夹
- 管理工具
- 存储项目数据归档
- 版本跟踪会话

## 📥 导入程序

### 导入方法
1. File → Import File → 浏览选择程序
2. 或从文件系统拖放到项目管理器文件夹

### 导入配置
- **文件格式**：自动检测或手动选择
  - PE, ELF, raw binary, intel hex, gzf 等
- **语言/编译器**：选择正确的语言/编译器对
- **项目文件夹**：可选择子文件夹
- **选项**：
  - 库搜索路径
  - 导入外部库（DLL）

### 实践技巧
- 启用 "Load External Libraries" 选项自动加载依赖库
- 使用 F1 查看导入选项详细帮助

## 🔍 自动分析 (Auto-Analysis)

### 启动分析
- 程序首次打开时自动启动
- 或使用 Analysis → Auto Analyze 手动启动

### 分析过程
#### 基本操作
1. 从入口点开始
2. 跟踪控制流进行反汇编
3. 在调用位置创建函数
4. 创建交叉引用

#### 可选功能
- 使用操作数引用创建代码/数据
- 使用反编译器信息生成 switch 语句
- 基于反编译器生成函数签名
- 解码混淆名称 (demangle)
- 识别并命名库函数
- 查找图像资源

### 分析策略

#### 分层分析方法（推荐）
1. **初始分析**：
   - 关闭推测性选项（如栈分析）
   - 保留引用、数据、函数分析器
   - 适用于大型二进制文件

2. **后续分析**：
   - 重新运行不同选项
   - 使用 One-Shot 分析器（Analysis → One-Shot）：
     - Decompiler Parameter ID
     - Decompiler Switch Analysis
     - Stack

#### 识别和修复问题
- **红色 X 标记**：表示错误流
- 检查错误书签确定问题分析器
- 使用分析脚本修复常见问题：
  - `FixupNoReturnFunction.java`：修复不返回函数
  - `FindPotentialDecompilerProblems.java`：查找反编译问题
  - `FindSharedReturnFunctions.java`：查找共享返回
  - `FindInstructionsNotInsideFunctionScript.java`：识别未在函数中的代码
  - `CreateFunctionsFromSelection.java`：手动创建函数

## 🛠️ CodeBrowser 工具

### 默认窗口布局
- Program Tree（程序树）
- Symbol Tree（符号树）
- Data Type Manager（数据类型管理器）
- Listing（代码列表）
- Console（控制台）
- Decompiler（反编译器）

### 自定义配置
- Windows 菜单添加额外窗口
- File → Configure 添加插件
- 布局和配置自动保存

## 📝 最佳实践

### 1. 项目组织
- 为相关程序创建独立项目
- 使用子文件夹组织程序
- 本地驱动器存储（性能优化）

### 2. 分析流程
- 先运行基本分析
- 检查分析日志（底部右侧）
- 使用脚本修复问题
- 按需运行专门分析器

### 3. 团队协作
- 使用 Ghidra Server 共享项目
- 利用版本控制功能
- 定期检入/检出变更

### 4. 工具定制
- 根据需求添加/移除插件
- 保存自定义工具配置
- 创建专用工具（不同任务不同工具）

## 🎯 实践练习

### 练习 1：创建项目
- 创建非共享项目
- 使用默认项目目录
- 命名为 "MyProject"

### 练习 2：导入程序
- 导入一个程序（如简单 CrackMe）
- 使用自动检测格式和语言
- 启用外部库加载选项

### 练习 3：自动分析
- 在 CodeBrowser 中打开程序
- 使用默认选项运行自动分析
- 检查分析结果

### 练习 4：基本导航
- 使用 Program Tree 查看程序结构
- 在 Symbol Tree 中浏览函数和数据
- 检查 Decompiler 输出

## 📚 进阶学习路径

1. **Intermediate Class**：深入学习高级分析技术
2. **Debugger**：学习动态调试
3. **Advanced Development**：学习插件开发
4. **BSim**：学习二进制相似性分析

## 🔗 资源链接

- 官方文档：https://ghidra.re/
- Beginner Class：https://ghidra.re/ghidra_docs/GhidraClass/Beginner/Introduction_to_Ghidra_Student_Guide.html
- API 文档：https://ghidra.re/ghidra_docs/api/index.html
- 语言规范：https://ghidra.re/ghidra_docs/languages/index.html

---

## 📊 学习检查点

- [ ] 成功安装并启动 Ghidra
- [ ] 创建第一个项目
- [ ] 导入一个程序
- [ ] 运行自动分析
- [ ] 理解 CodeBrowser 布局
- [ ] 使用基本导航功能
- [ ] 查看反编译器输出

## 🎓 下一步

1. 实践分析一个简单程序
2. 学习使用标记和注释功能
3. 掌握搜索和选择功能
4. 学习数据类型应用
5. 深入学习反编译器使用

---

*学习时间：2026-02-17 08:00*
*预计掌握时间：1-2 小时实践*
