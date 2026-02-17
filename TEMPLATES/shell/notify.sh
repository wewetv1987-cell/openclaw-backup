#!/bin/bash
# 多渠道通知脚本模板
# 用法: ./notify.sh "消息内容" [渠道]

set -e

MESSAGE="$1"
CHANNEL="${2:-telegram}"

# 配置 (从环境变量读取)
# TELEGRAM_BOT_TOKEN=xxx
# TELEGRAM_CHAT_ID=xxx
# DISCORD_WEBHOOK_URL=xxx
# SLACK_WEBHOOK_URL=xxx

send_telegram() {
    local msg="$1"
    curl -s -X POST "https://api.telegram.org/bot${TELEGRAM_BOT_TOKEN}/sendMessage" \
        -d chat_id="${TELEGRAM_CHAT_ID}" \
        -d text="${msg}" \
        -d parse_mode="Markdown" > /dev/null
    echo "✅ Telegram 通知已发送"
}

send_discord() {
    local msg="$1"
    curl -s -X POST "${DISCORD_WEBHOOK_URL}" \
        -H "Content-Type: application/json" \
        -d "{\"content\":\"${msg}\"}" > /dev/null
    echo "✅ Discord 通知已发送"
}

send_slack() {
    local msg="$1"
    curl -s -X POST "${SLACK_WEBHOOK_URL}" \
        -H "Content-Type: application/json" \
        -d "{\"text\":\"${msg}\"}" > /dev/null
    echo "✅ Slack 通知已发送"
}

# OpenClaw 内置通知 (推荐)
send_openclaw() {
    local msg="$1"
    # 使用 OpenClaw message tool
    echo "📤 通过 OpenClaw 发送: $msg"
}

# 主逻辑
if [ -z "$MESSAGE" ]; then
    echo "❌ 请提供消息内容"
    echo "用法: $0 \"消息\" [telegram|discord|slack|openclaw]"
    exit 1
fi

case "$CHANNEL" in
    telegram)
        send_telegram "$MESSAGE"
        ;;
    discord)
        send_discord "$MESSAGE"
        ;;
    slack)
        send_slack "$MESSAGE"
        ;;
    openclaw)
        send_openclaw "$MESSAGE"
        ;;
    all)
        send_telegram "$MESSAGE"
        send_discord "$MESSAGE"
        send_slack "$MESSAGE"
        ;;
    *)
        echo "❌ 未知渠道: $CHANNEL"
        exit 1
        ;;
esac
