#!/bin/bash
# Memos CLI - 与 Memos 实例交互
# 用法: ./memos.sh <command> [args]

set -e

# 配置
MEMOS_URL="${MEMOS_URL:-}"
MEMOS_TOKEN="${MEMOS_TOKEN:-}"

# 颜色
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log_info() { echo -e "${GREEN}[INFO]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }
log_memo() { echo -e "${BLUE}[MEMO]${NC} $1"; }

# 检查配置
check_config() {
    if [ -z "$MEMOS_URL" ] || [ -z "$MEMOS_TOKEN" ]; then
        log_error "请设置环境变量:"
        echo "  export MEMOS_URL=https://your-instance.com"
        echo "  export MEMOS_TOKEN=your-token"
        exit 1
    fi
}

# API 请求
api_request() {
    local method="$1"
    local endpoint="$2"
    local data="$3"
    
    local url="${MEMOS_URL}${endpoint}"
    local args=(-s -X "$method" -H "Authorization: Bearer ${MEMOS_TOKEN}" -H "Content-Type: application/json")
    
    if [ -n "$data" ]; then
        args+=(-d "$data")
    fi
    
    curl "${args[@]}" "$url"
}

# 创建 memo
create_memo() {
    local content="$1"
    local visibility="${2:-PRIVATE}"
    
    if [ -z "$content" ]; then
        log_error "请提供 memo 内容"
        exit 1
    fi
    
    local data=$(cat <<EOF
{
    "content": "$(echo "$content" | sed 's/"/\\"/g' | sed ':a;N;$!ba;s/\n/\\n/g')",
    "visibility": "$visibility"
}
EOF
)
    
    log_info "创建 memo..."
    local result=$(api_request "POST" "/api/v1/memo" "$data")
    
    if echo "$result" | grep -q '"id"'; then
        local id=$(echo "$result" | grep -o '"id":[0-9]*' | head -1 | cut -d: -f2)
        log_info "Memo 创建成功! ID: $id"
        log_memo "$content"
    else
        log_error "创建失败: $result"
    fi
}

# 列出 memos
list_memos() {
    local limit="${1:-10}"
    
    log_info "获取最近 $limit 条 memos..."
    local result=$(api_request "GET" "/api/v1/memo?pageSize=$limit")
    
    echo "$result" | python3 -c "
import sys, json
try:
    data = json.load(sys.stdin)
    memos = data.get('memos', data) if isinstance(data, dict) else data
    for m in memos[:$limit]:
        id = m.get('id', '?')
        content = m.get('content', '')[:100]
        created = m.get('createdTs', m.get('createTime', ''))
        print(f'\033[0;34m[{id}]\033[0m {content}...')
        print(f'       创建于: {created}')
        print()
except Exception as e:
    print(f'解析失败: {e}')
    sys.exit(1)
" 2>/dev/null || echo "$result"
}

# 搜索 memos
search_memos() {
    local query="$1"
    
    if [ -z "$query" ]; then
        log_error "请提供搜索关键词"
        exit 1
    fi
    
    log_info "搜索: $query"
    local result=$(api_request "GET" "/api/v1/memo?filter=content.contains('$query')")
    
    echo "$result" | python3 -c "
import sys, json
try:
    data = json.load(sys.stdin)
    memos = data.get('memos', data) if isinstance(data, dict) else data
    if not memos:
        print('未找到匹配的 memo')
    for m in memos:
        id = m.get('id', '?')
        content = m.get('content', '')
        print(f'\033[0;34m[{id}]\033[0m {content}')
        print()
except Exception as e:
    print(f'解析失败: {e}')
" 2>/dev/null || echo "$result"
}

# 获取单条 memo
get_memo() {
    local id="$1"
    
    if [ -z "$id" ]; then
        log_error "请提供 memo ID"
        exit 1
    fi
    
    log_info "获取 memo #$id..."
    api_request "GET" "/api/v1/memo/$id" | python3 -m json.tool 2>/dev/null || cat
}

# 删除 memo
delete_memo() {
    local id="$1"
    
    if [ -z "$id" ]; then
        log_error "请提供 memo ID"
        exit 1
    fi
    
    log_info "删除 memo #$id..."
    api_request "DELETE" "/api/v1/memo/$id"
    log_info "已删除"
}

# 主逻辑
check_config

case "${1:-}" in
    create|add|new)
        create_memo "$2" "$3"
        ;;
    list|ls)
        list_memos "${2:-10}"
        ;;
    search|find)
        search_memos "$2"
        ;;
    get|show)
        get_memo "$2"
        ;;
    delete|rm)
        delete_memo "$2"
        ;;
    *)
        echo "Memos CLI"
        echo ""
        echo "用法: $0 <command> [args]"
        echo ""
        echo "命令:"
        echo "  create <content> [visibility]  创建 memo"
        echo "  list [limit]                   列出 memos (默认 10)"
        echo "  search <query>                 搜索 memos"
        echo "  get <id>                       获取单条 memo"
        echo "  delete <id>                    删除 memo"
        echo ""
        echo "示例:"
        echo "  $0 create '今天学习了 Memos API'"
        echo "  $0 list 20"
        echo "  $0 search 'API'"
        ;;
esac
