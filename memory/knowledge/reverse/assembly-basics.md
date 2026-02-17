# x86 汇编语言基础

> 学习时间: 2026-02-17 05:05
> 来源: University of Virginia CS216 Guide
> 难度: 入门

---

## 📚 概述

x86 汇编语言是与 x86 处理器直接交互的低级语言。Intel x86 指令集手册超过 2900 页，本笔记聚焦最实用的核心内容。

---

## 🔧 寄存器 (Registers)

### 8个32位通用寄存器

现代 x86 处理器（386+）有 8 个 32 位通用寄存器：

| 寄存器 | 历史用途 | 现代用途 |
|--------|---------|---------|
| **EAX** | 累加器 | 通用、算术运算 |
| **EBX** | 基址寄存器 | 通用 |
| **ECX** | 计数器 | 循环索引 |
| **EDX** | 数据寄存器 | 通用 |
| **ESI** | 源索引 | 字符串/数组操作 |
| **EDI** | 目标索引 | 字符串/数组操作 |
| **ESP** | 栈指针 | **特殊：指向栈顶** |
| **EBP** | 基址指针 | **特殊：栈帧基址** |

### 子寄存器访问

EAX/EBX/ECX/EDX 可以访问部分：

```
32位: EAX (全32位)
16位: AX  (低16位)
8位:  AL  (低8位)  + AH (高8位)
```

**示例**:
```asm
mov ax, 5      ; 只改变 EAX 的低16位
mov al, 10     ; 只改变 AX 的低8位
```

---

## 🧠 内存和寻址模式

### 声明静态数据

```asm
.DATA

var  DB 64        ; 声明1字节，值64
var2 DB ?         ; 声明1字节，未初始化
X    DW ?         ; 声明2字节，未初始化
Y    DD 30000     ; 声明4字节，值30000
```

**指令说明**:
- `DB` - Define Byte (1字节)
- `DW` - Define Word (2字节)
- `DD` - Define Double Word (4字节)

### 数组声明

```asm
; 方法1: 直接列出
Z DD 1, 2, 3     ; 3个4字节值: [1, 2, 3]

; 方法2: DUP 指令
bytes DB 10 DUP(?)   ; 10个未初始化字节
arr   DD 100 DUP(0)  ; 100个4字节，全是0

; 方法3: 字符串
str DB 'hello',0     ; ASCII字符串 + null终止符
```

### 内存寻址

x86 支持灵活的地址计算：最多2个寄存器 + 1个常量，其中一个寄存器可以乘以 2/4/8。

**有效示例**:
```asm
mov eax, [ebx]           ; 直接取 EBX 指向的4字节
mov [var], ebx           ; 将 EBX 存入 var 地址
mov eax, [esi-4]         ; ESI - 4 的地址
mov [esi+eax], cl        ; ESI + EAX 的地址
mov edx, [esi+4*ebx]     ; ESI + 4*EBX 的地址
```

**无效示例**:
```asm
mov eax, [ebx-ecx]       ; ❌ 只能加，不能减寄存器
mov [eax+esi+edi], ebx   ; ❌ 最多2个寄存器
```

### 大小指令

当大小不明确时，使用大小指令：

```asm
mov BYTE PTR [ebx], 2    ; 移入1字节
mov WORD PTR [ebx], 2    ; 移入2字节 (16位)
mov DWORD PTR [ebx], 2   ; 移入4字节 (32位)
```

---

## 📦 数据移动指令

### `mov` - 移动数据

```asm
mov <reg>, <reg>    ; 寄存器到寄存器
mov <reg>, <mem>    ; 内存到寄存器
mov <mem>, <reg>    ; 寄存器到内存
mov <reg>, <const>  ; 常量到寄存器
mov <mem>, <const>  ; 常量到内存
```

**示例**:
```asm
mov eax, ebx            ; 复制 EBX 到 EAX
mov byte ptr [var], 5   ; 存储5到 var 的字节
```

**注意**: 不能直接内存到内存！

```asm
mov [var1], [var2]      ; ❌ 无效
; 正确做法:
mov eax, [var2]         ; 先加载到寄存器
mov [var1], eax         ; 再存储
```

### `push` - 压栈

将操作数压入栈顶：

```asm
push eax    ; ESP -= 4, [ESP] = EAX
push [var]  ; ESP -= 4, [ESP] = [var]
push 12345  ; ESP -= 4, [ESP] = 12345
```

**原理**:
1. ESP 先减 4（栈向下增长）
2. 将值存入 [ESP]

### `pop` - 出栈

从栈顶弹出数据：

```asm
pop edi     ; EDI = [ESP], ESP += 4
pop [ebx]   ; [EBX] = [ESP], ESP += 4
```

**原理**:
1. 将 [ESP] 的值加载到目标
2. ESP 加 4

### `lea` - 加载有效地址

计算地址但不访问内存：

```asm
lea edi, [ebx+4*esi]    ; EDI = EBX + 4*ESI
lea eax, [var]          ; EAX = var 的地址
```

**用途**: 获取指针，不是值！

---

## 🔢 算术和逻辑指令

### `add` - 加法

```asm
add eax, 10             ; EAX = EAX + 10
add BYTE PTR [var], 10  ; [var] += 10
```

### `sub` - 减法

```asm
sub al, ah      ; AL = AL - AH
sub eax, 216    ; EAX -= 216
```

### `inc` / `dec` - 自增/自减

```asm
inc eax                 ; EAX += 1
dec DWORD PTR [var]     ; [var] -= 1
```

### `imul` - 整数乘法

**两操作数形式**:
```asm
imul eax, [var]     ; EAX *= [var]
```

**三操作数形式**:
```asm
imul esi, edi, 25   ; ESI = EDI * 25
```

### `idiv` - 整数除法

**使用 64 位被除数** `EDX:EAX`:

```asm
idiv ebx            ; EDX:EAX / EBX
                    ; 商 → EAX
                    ; 余数 → EDX
```

**重要**: 除法前必须设置 EDX（通常用 `cdq` 指令）

### `and` / `or` / `xor` - 位运算

```asm
and eax, 0xFF       ; EAX &= 0xFF (掩码)
or  eax, 0x80       ; EAX |= 0x80 (设置位)
xor eax, eax        ; EAX = 0 (清零技巧)
```

---

## 🔄 控制流指令

### `jmp` - 无条件跳转

```asm
jmp label    ; 跳转到 label
```

### `cmp` - 比较

比较两个操作数（实际做减法但不存储结果）:

```asm
cmp eax, 10    ; 比较 EAX 和 10
```

### 条件跳转

基于 `cmp` 的结果：

| 指令 | 条件 | 含义 |
|------|------|------|
| `je` | equal | 相等跳转 |
| `jne` | not equal | 不等跳转 |
| `jl` | less than | 小于跳转 |
| `jle` | less or equal | 小于等于 |
| `jg` | greater than | 大于跳转 |
| `jge` | greater or equal | 大于等于 |

**示例**:
```asm
cmp eax, 10
je  equal_label      ; 如果 EAX == 10，跳转
jg  greater_label    ; 如果 EAX > 10，跳转
; 否则继续执行
```

### `call` / `ret` - 函数调用

```asm
call function_name   ; 调用函数
; ... 函数执行 ...
ret                  ; 返回调用者
```

---

## 🏗️ 调用约定

### 栈帧结构

```
高地址
+------------------+
|   参数 N         |
|   ...            |
|   参数 1         |
|   返回地址       | ← call 指令压入
+------------------+
|   旧的 EBP       | ← push ebp
+------------------+ ← EBP 指向这里
|   局部变量       |
|   ...            |
+------------------+ ← ESP 指向栈顶
低地址
```

### 函数序言和尾声

**标准函数序言**:
```asm
push ebp            ; 保存旧的 EBP
mov  ebp, esp       ; 设置新的 EBP
sub  esp, 16        ; 分配16字节局部变量空间
```

**标准函数尾声**:
```asm
mov  esp, ebp       ; 恢复 ESP
pop  ebp            ; 恢复 EBP
ret                 ; 返回
```

---

## 💡 实用技巧

### 1. 清零寄存器

```asm
xor eax, eax    ; 比 mov eax, 0 更快
```

### 2. 测试是否为零

```asm
test eax, eax   ; 等价于 cmp eax, 0 但更快
jz  is_zero
```

### 3. 字符串长度计算

```asm
; 计算以 null 结尾的字符串长度
mov edi, string_ptr
xor eax, eax        ; 计数器清零
count_loop:
    cmp byte ptr [edi + eax], 0
    je  done
    inc eax
    jmp count_loop
done:
    ; EAX 现在包含字符串长度
```

### 4. 数组访问

```asm
; 访问 int array[100] 的第 i 个元素
mov eax, [array + 4*esi]    ; ESI 是索引，int 是4字节
```

---

## 🔍 x86 vs x64

### x64 (AMD64) 主要变化

1. **寄存器数量增加**:
   - 8 → 16 个通用寄存器 (RAX-R15)
   - 所有寄存器扩展到 64 位

2. **寄存器名称变化**:
   - EAX → RAX (64位)
   - 仍可访问 EAX (低32位), AX (16位), AL (8位)

3. **新增寄存器**:
   - R8-R15 (8个新的64位寄存器)

4. **调用约定变化**:
   - 前4个参数通过寄存器传递 (RCX, RDX, R8, R9)
   - 其余通过栈传递

---

## 🎯 学习清单

- [x] 理解 8 个通用寄存器的作用
- [x] 掌握内存寻址模式
- [x] 学会 mov/push/pop/lea
- [x] 掌握算术指令 (add/sub/inc/dec/imul/idiv)
- [x] 理解控制流 (cmp/jmp/call/ret)
- [x] 了解栈帧结构
- [ ] 实践: 写第一个汇编程序
- [ ] 实践: 分析简单的 Crackme
- [ ] 进阶: 学习 x64 汇编
- [ ] 进阶: 学习浮点运算 (SSE/AVX)

---

## 📚 参考资料

- Intel x86 Instruction Set Reference
- University of Virginia CS216 Guide
- "PC Assembly Language" by Paul Carter
- Ghidra 官方文档

---

## 💾 示例代码

### Hello World (MASM 语法)

```asm
.386
.model flat, stdcall
.stack 4096

ExitProcess PROTO, dwExitCode:DWORD

.data
    hello BYTE "Hello, World!", 0

.code
main PROC
    ; 打印字符串 (这里简化，实际需要调用 API)
    ; ...

    ; 退出程序
    push 0
    call ExitProcess
main ENDP
END main
```

### 简单函数示例

```asm
; int add_numbers(int a, int b)
; 返回 a + b
add_numbers PROC
    push ebp
    mov  ebp, esp

    ; 参数在 [ebp+8] 和 [ebp+12]
    mov  eax, [ebp+8]    ; EAX = a
    add  eax, [ebp+12]   ; EAX += b

    pop  ebp
    ret
add_numbers ENDP
```

---

*学习时长: 25分钟 | 掌握程度: 基础*
*下一步: 安装 Ghidra，实践第一个 crackme*
