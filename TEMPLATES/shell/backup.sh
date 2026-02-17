#!/bin/bash
# 备份脚本模板
# 用法: ./backup.sh <源目录> <目标目录> [保留数量]

set -e

# 配置
SOURCE="${1:-.}"
DEST="${2:-./backups}"
KEEP="${3:-7}"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_NAME="backup_${TIMESTAMP}"

# 颜色输出
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

log_info() { echo -e "${GREEN}[INFO]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

# 检查源目录
if [ ! -d "$SOURCE" ]; then
    log_error "源目录不存在: $SOURCE"
    exit 1
fi

# 创建目标目录
mkdir -p "$DEST"

# 执行备份
log_info "开始备份: $SOURCE -> $DEST/$BACKUP_NAME"
rsync -av --progress "$SOURCE/" "$DEST/$BACKUP_NAME/"

# 压缩备份
log_info "压缩备份..."
cd "$DEST"
tar -czf "${BACKUP_NAME}.tar.gz" "$BACKUP_NAME"
rm -rf "$BACKUP_NAME"

# 清理旧备份
log_info "清理旧备份 (保留最近 $KEEP 个)..."
ls -t backup_*.tar.gz | tail -n +$((KEEP + 1)) | xargs -r rm

# 完成
log_info "备份完成: ${BACKUP_NAME}.tar.gz"
log_info "大小: $(du -h "${BACKUP_NAME}.tar.gz" | cut -f1)"
