#!/usr/bin/env node
/**
 * Memos API Client for Node.js
 * 用于 OpenClaw 自动化集成
 */

const axios = require('axios');

class MemosClient {
    constructor(url, token) {
        this.url = url || process.env.MEMOS_URL;
        this.token = token || process.env.MEMOS_TOKEN;
        
        if (!this.url || !this.token) {
            throw new Error('MEMOS_URL 和 MEMOS_TOKEN 必须设置');
        }
        
        this.client = axios.create({
            baseURL: `${this.url}/api/v1`,
            headers: {
                'Authorization': `Bearer ${this.token}`,
                'Content-Type': 'application/json',
            },
        });
    }
    
    /**
     * 创建 memo
     * @param {string} content - memo 内容
     * @param {object} options - 可选配置
     */
    async create(content, options = {}) {
        const { visibility = 'PRIVATE', tags = [] } = options;
        
        // 添加标签
        let finalContent = content;
        if (tags.length > 0) {
            finalContent += `\n\n${tags.map(t => `#${t}`).join(' ')}`;
        }
        
        const response = await this.client.post('/memo', {
            content: finalContent,
            visibility,
        });
        
        return response.data;
    }
    
    /**
     * 列出 memos
     * @param {object} options - 查询选项
     */
    async list(options = {}) {
        const { limit = 10, offset = 0 } = options;
        
        const response = await this.client.get('/memo', {
            params: { pageSize: limit, offset },
        });
        
        return response.data.memos || response.data;
    }
    
    /**
     * 搜索 memos
     * @param {string} query - 搜索关键词
     */
    async search(query) {
        const response = await this.client.get('/memo', {
            params: { filter: `content.contains('${query}')` },
        });
        
        return response.data.memos || response.data;
    }
    
    /**
     * 获取单条 memo
     * @param {number|string} id - memo ID
     */
    async get(id) {
        const response = await this.client.get(`/memo/${id}`);
        return response.data;
    }
    
    /**
     * 更新 memo
     * @param {number|string} id - memo ID
     * @param {object} updates - 更新内容
     */
    async update(id, updates) {
        const response = await this.client.patch(`/memo/${id}`, updates);
        return response.data;
    }
    
    /**
     * 删除 memo
     * @param {number|string} id - memo ID
     */
    async delete(id) {
        await this.client.delete(`/memo/${id}`);
        return true;
    }
    
    /**
     * 快速记录 (便捷方法)
     * @param {string} content - 内容
     * @param {string[]} tags - 标签
     */
    async quick(content, tags = []) {
        return this.create(content, { tags, visibility: 'PRIVATE' });
    }
    
    /**
     * 记录每日总结
     * @param {object} summary - 总结内容
     */
    async dailySummary(summary) {
        const { completed = [], tomorrow = [], notes = '' } = summary;
        const date = new Date().toLocaleDateString('zh-CN');
        
        const content = `# 📊 每日总结 - ${date}

## ✅ 完成事项
${completed.map(t => `- ${t}`).join('\n') || '- 无'}

## 📅 明日计划
${tomorrow.map(t => `- ${t}`).join('\n') || '- 无'}

## 📝 备注
${notes || '无'}

#daily #summary`;
        
        return this.create(content, { visibility: 'PRIVATE' });
    }
}

// CLI 支持
if (require.main === module) {
    const client = new MemosClient();
    const [,, cmd, ...args] = process.argv;
    
    const commands = {
        create: () => client.create(args.join(' ')),
        list: () => client.list({ limit: parseInt(args[0]) || 10 }),
        search: () => client.search(args[0]),
        get: () => client.get(args[0]),
        delete: () => client.delete(args[0]),
    };
    
    (async () => {
        try {
            if (!cmd || !commands[cmd]) {
                console.log('用法: node memos.js <create|list|search|get|delete> [args]');
                process.exit(1);
            }
            
            const result = await commands[cmd]();
            console.log(JSON.stringify(result, null, 2));
        } catch (error) {
            console.error('错误:', error.message);
            process.exit(1);
        }
    })();
}

module.exports = MemosClient;
