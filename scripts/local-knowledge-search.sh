#!/bin/bash

# 本地优先知识搜索脚本
# 用法: ./local-knowledge-search.sh "查询内容"

set -e

QUERY="$1"
if [ -z "$QUERY" ]; then
    echo "用法: $0 \"查询内容\""
    exit 1
fi

WORKSPACE="/Users/mac/.openclaw/workspace"
LOG_FILE="$WORKSPACE/memory/logs/search-$(date +%Y%m%d).log"

# 创建日志目录
mkdir -p "$(dirname "$LOG_FILE")"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

log "=== 开始搜索: '$QUERY' ==="

# 步骤1: 分析查询类型
analyze_query() {
    local query="$1"
    
    # 关键词匹配
    case "$query" in
        *金融*|*投资*|*股票*|*ETF*|*财富*)
            echo "finance"
            ;;
        *编程*|*代码*|*Python*|*JavaScript*|*Docker*|*Git*)
            echo "programming"
            ;;
        *逆向*|*Ghidra*|*反编译*|*调试*)
            echo "reverse"
            ;;
        *Vibe*|*提示词*|*Prompt*|*AI*)
            echo "vibe-coding"
            ;;
        *配置*|*设置*|*OpenClaw*|*模型*)
            echo "config"
            ;;
        *)
            echo "general"
            ;;
    esac
}

QUERY_TYPE=$(analyze_query "$QUERY")
log "查询类型: $QUERY_TYPE"

# 步骤2: 搜索本地记忆
search_local() {
    local query="$1"
    local type="$2"
    
    log "搜索本地记忆..."
    
    # 搜索优先级
    local search_paths=()
    
    case "$type" in
        finance)
            search_paths=("$WORKSPACE/memory/knowledge/finance" "$WORKSPACE/memory")
            ;;
        programming)
            search_paths=("$WORKSPACE/memory/knowledge/programming" "$WORKSPACE/memory")
            ;;
        reverse)
            search_paths=("$WORKSPACE/memory/knowledge/reverse" "$WORKSPACE/memory")
            ;;
        vibe-coding)
            search_paths=("$WORKSPACE/memory/knowledge/vibe-coding" "$WORKSPACE/memory")
            ;;
        config)
            search_paths=("$WORKSPACE/memory" "$WORKSPACE")
            ;;
        *)
            search_paths=("$WORKSPACE/memory" "$WORKSPACE")
            ;;
    esac
    
    # 添加每日记忆
    search_paths+=("$WORKSPACE/memory/daily")
    
    # 搜索文件
    local results=""
    for path in "${search_paths[@]}"; do
        if [ -d "$path" ]; then
            log "搜索路径: $path"
            local found=$(find "$path" -name "*.md" -type f -exec grep -l -i "$query" {} \; 2>/dev/null | head -5)
            if [ -n "$found" ]; then
                results="$results$found"$'\n'
            fi
        fi
    done
    
    echo "$results"
}

# 步骤3: 提取相关内容
extract_content() {
    local files="$1"
    local query="$2"
    
    if [ -z "$files" ]; then
        echo ""
        return
    fi
    
    log "从文件中提取内容..."
    
    local content=""
    while IFS= read -r file; do
        if [ -f "$file" ]; then
            log "分析文件: $(basename "$file")"
            # 提取包含查询的行及其上下文
            local extracted=$(grep -i -B2 -A2 "$query" "$file" 2>/dev/null | head -20)
            if [ -n "$extracted" ]; then
                content="$content=== $(basename "$file") ==="$'\n'
                content="$content$extracted"$'\n\n'
            fi
        fi
    done <<< "$files"
    
    echo "$content"
}

# 执行搜索
FOUND_FILES=$(search_local "$QUERY" "$QUERY_TYPE")
LOCAL_CONTENT=$(extract_content "$FOUND_FILES" "$QUERY")

if [ -n "$LOCAL_CONTENT" ]; then
    log "✅ 找到本地相关内容"
    echo ""
    echo "📚 本地知识库中找到相关内容:"
    echo "================================"
    echo "$LOCAL_CONTENT"
    echo "================================"
    log "搜索完成: 使用本地知识"
else
    log "❌ 未找到本地相关内容"
    echo ""
    echo "⚠️  本地知识库中未找到相关内容"
    echo "建议: 调用模型获取答案，然后将知识保存到本地"
    
    # 建议保存路径
    case "$QUERY_TYPE" in
        finance)
            SAVE_PATH="$WORKSPACE/memory/knowledge/finance/$(date +%Y%m%d)-${QUERY:0:20}.md"
            ;;
        programming)
            SAVE_PATH="$WORKSPACE/memory/knowledge/programming/$(date +%Y%m%d)-${QUERY:0:20}.md"
            ;;
        reverse)
            SAVE_PATH="$WORKSPACE/memory/knowledge/reverse/$(date +%Y%m%d)-${QUERY:0:20}.md"
            ;;
        vibe-coding)
            SAVE_PATH="$WORKSPACE/memory/knowledge/vibe-coding/$(date +%Y%m%d)-${QUERY:0:20}.md"
            ;;
        *)
            SAVE_PATH="$WORKSPACE/memory/knowledge/general/$(date +%Y%m%d)-${QUERY:0:20}.md"
            ;;
    esac
    
    echo ""
    echo "💾 获取答案后建议保存到:"
    echo "   $SAVE_PATH"
    log "搜索完成: 需要调用模型"
fi

log "=== 搜索结束 ==="
echo ""