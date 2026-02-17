# TOOLS.md - Local Notes

Skills define _how_ tools work. This file is for _your_ specifics — the stuff that's unique to your setup.

## What Goes Here

Things like:

- Camera names and locations
- SSH hosts and aliases
- Preferred voices for TTS
- Speaker/room names
- Device nicknames
- Anything environment-specific

## Examples

```markdown
### Cameras

- living-room → Main area, 180° wide angle
- front-door → Entrance, motion-triggered

### SSH

- home-server → 192.168.1.100, user: admin

### TTS

- Preferred voice: "Nova" (warm, slightly British)
- Default speaker: Kitchen HomePod
```

## Why Separate?

Skills are shared. Your setup is yours. Keeping them apart means you can update skills without losing your notes, and share skills without leaking your infrastructure.

---

## Memos 配置

### 环境变量 (推荐)
```bash
export MEMOS_URL="https://your-memos-instance.com"
export MEMOS_TOKEN="your-api-token"
```

### 或在 ~/.zshrc 中设置
```bash
# Memos 配置
MEMOS_URL="https://your-memos-instance.com"
MEMOS_TOKEN="your-api-token"
```

### 用途
- 快速记录想法和笔记
- 每日总结自动同步
- 任务完成记录

---

Add whatever helps you do your job. This is your cheat sheet.
