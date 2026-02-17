#!/bin/bash
# Moltbook 快速配置脚本

set -e

echo "🦊 Claw - Moltbook 配置向导"
echo "============================"
echo ""

CONFIG_FILE="$HOME/.config/moltbook/credentials.json"

# 检查配置文件是否存在
if [ ! -f "$CONFIG_FILE" ]; then
    echo "📦 创建配置目录..."
    mkdir -p "$(dirname "$CONFIG_FILE")"
    echo '{"api_key":"NEED_API_KEY","agent_name":"Claw"}' > "$CONFIG_FILE"
fi

echo "📋 当前配置:"
cat "$CONFIG_FILE"
echo ""

# 检查是否需要配置
if grep -q "NEED_API_KEY" "$CONFIG_FILE"; then
    echo "⚠️  需要配置 API Key"
    echo ""
    echo "步骤:"
    echo "1. 访问 https://www.moltbook.com"
    echo "2. 注册/登录账号"
    echo "3. 在 Dashboard 获取 API Key"
    echo "4. 运行此脚本并输入 API Key"
    echo ""

    read -p "你有 API Key 了吗？(y/n) " -n 1 -r
    echo ""

    if [[ $REPLY =~ ^[Yy]$ ]]; then
        read -p "请输入你的 Moltbook API Key: " API_KEY

        if [ -n "$API_KEY" ]; then
            # 更新配置文件
            cat > "$CONFIG_FILE" << EOF
{
  "api_key": "$API_KEY",
  "agent_name": "Claw"
}
EOF
            echo "✅ API Key 已保存"
        else
            echo "❌ API Key 不能为空"
            exit 1
        fi
    else
        echo "⏸️  稍后配置。请访问 https://www.moltbook.com 获取 API Key"
        exit 0
    fi
fi

echo ""
echo "🧪 测试连接..."

# 检查技能目录
SKILL_DIR="$(dirname "$0")/../skills/moltbook-interact"
if [ -d "$SKILL_DIR" ]; then
    cd "$SKILL_DIR"

    if [ -f "scripts/moltbook.sh" ]; then
        chmod +x scripts/moltbook.sh
        ./scripts/moltbook.sh test
    else
        echo "⚠️  脚本文件不存在，跳过测试"
    fi
else
    echo "⚠️  技能目录不存在，跳过测试"
fi

echo ""
echo "✅ 配置完成！"
echo ""
echo "📚 使用方法:"
echo "  浏览热门: cd workspace/skills/moltbook-interact && ./scripts/moltbook.sh hot 10"
echo "  发布帖子: ./scripts/moltbook.sh create \"标题\" \"内容\""
echo "  回复帖子: ./scripts/moltbook.sh reply <post_id> \"回复内容\""
echo ""
echo "📖 完整文档: workspace/MOLTBOOK_SETUP.md"
