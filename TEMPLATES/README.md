# TEMPLATES 目录

> 常用自动化脚本模板库

## 目录结构

```
TEMPLATES/
├── shell/          # Shell 脚本模板
│   ├── backup.sh       # 备份脚本
│   ├── notify.sh       # 通知脚本
│   └── file-ops.sh     # 文件操作
├── python/         # Python 脚本模板
│   ├── data-convert.py # 数据转换
│   ├── scraper.py      # 爬虫模板
│   └── api-client.py   # API 客户端
├── nodejs/         # Node.js 脚本模板
│   ├── api-call.js     # API 调用
│   ├── image-batch.js  # 图片处理
│   └── file-watch.js   # 文件监控
├── workflows/      # 工作流定义
│   ├── n8n/            # n8n 工作流
│   └── make/            # Make 场景
└── snippets/       # 代码片段
    ├── auth/           # 认证相关
    ├── db/             # 数据库操作
    └── utils/          # 工具函数
```

## 模板索引

### Shell 脚本
| 文件 | 用途 | 依赖 |
|-----|------|-----|
| backup.sh | 文件/目录备份 | rsync, gzip |
| notify.sh | 多渠道通知 | curl |
| file-ops.sh | 批量文件操作 | find, xargs |
| memos.sh | Memos 快速记录 | curl, jq |

### 技能脚本
| 文件 | 用途 | 依赖 |
|-----|------|-----|
| skills/memos/memos.sh | Memos CLI | curl, jq |
| skills/memos/memos.js | Memos Node.js 客户端 | axios |

### Python 脚本
| 文件 | 用途 | 依赖 |
|-----|------|-----|
| data-convert.py | 数据格式转换 | pandas, openpyxl |
| scraper.py | 网页爬虫 | requests, beautifulsoup4 |
| api-client.py | API 调用封装 | requests, aiohttp |

### Node.js 脚本
| 文件 | 用途 | 依赖 |
|-----|------|-----|
| api-call.js | REST API 调用 | axios |
| image-batch.js | 图片批量处理 | sharp |
| file-watch.js | 文件变更监控 | chokidar |

## 使用方法

1. 复制模板到目标目录
2. 修改配置参数
3. 安装必要依赖
4. 执行脚本

```bash
# 示例：使用备份模板
cp TEMPLATES/shell/backup.sh ~/scripts/
chmod +x ~/scripts/backup.sh
~/scripts/backup.sh /path/to/source /path/to/dest
```

---
*最后更新: 2026-02-17*
