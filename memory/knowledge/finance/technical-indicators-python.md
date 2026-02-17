# Python 技术指标实现

> 学习时间: 2026-02-17 05:55
> 来源: 实践学习 + 理论巩固
> 难度: 中级

---

## 📚 概述

使用 Python 和 pandas 实现常用技术指标。

---

## 🔧 环境准备

```python
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt

# 假设 df 是包含 'Close', 'High', 'Low', 'Volume' 列的 DataFrame
# df = pd.read_csv('stock_data.csv')
```

---

## 📈 移动平均线 (MA)

### 简单移动平均 (SMA)

```python
def calculate_sma(data, window):
    """
    计算简单移动平均线

    参数:
        data: 价格序列 (Series)
        window: 窗口期 (int)

    返回:
        SMA 序列
    """
    return data.rolling(window=window).mean()

# 使用示例
df['SMA_20'] = calculate_sma(df['Close'], 20)
df['SMA_50'] = calculate_sma(df['Close'], 50)

# 金叉死叉信号
df['Signal'] = 0
df.loc[df['SMA_20'] > df['SMA_50'], 'Signal'] = 1  # 金叉
df.loc[df['SMA_20'] < df['SMA_50'], 'Signal'] = -1 # 死叉
```

### 指数移动平均 (EMA)

```python
def calculate_ema(data, window):
    """
    计算指数移动平均线

    EMA 对近期价格赋予更高权重
    """
    return data.ewm(span=window, adjust=False).mean()

# 使用示例
df['EMA_12'] = calculate_ema(df['Close'], 12)
df['EMA_26'] = calculate_ema(df['Close'], 26)
```

---

## 📊 RSI (相对强弱指数)

```python
def calculate_rsi(data, window=14):
    """
    计算相对强弱指数

    参数:
        data: 价格序列
        window: 窗口期 (默认14)

    返回:
        RSI 序列 (0-100)
    """
    # 计算价格变化
    delta = data.diff()

    # 分离上涨和下跌
    gain = (delta.where(delta > 0, 0)).rolling(window=window).mean()
    loss = (-delta.where(delta < 0, 0)).rolling(window=window).mean()

    # 计算相对强度
    rs = gain / loss

    # 计算 RSI
    rsi = 100 - (100 / (1 + rs))

    return rsi

# 使用示例
df['RSI'] = calculate_rsi(df['Close'], 14)

# 超买超卖信号
df['RSI_Signal'] = 'Neutral'
df.loc[df['RSI'] > 70, 'RSI_Signal'] = 'Overbought'  # 超买
df.loc[df['RSI'] < 30, 'RSI_Signal'] = 'Oversold'    # 超卖
```

---

## 📉 MACD (移动平均收敛散度)

```python
def calculate_macd(data, fast=12, slow=26, signal=9):
    """
    计算 MACD 指标

    参数:
        data: 价格序列
        fast: 快线周期 (默认12)
        slow: 慢线周期 (默认26)
        signal: 信号线周期 (默认9)

    返回:
        DataFrame: MACD Line, Signal Line, Histogram
    """
    # 计算 EMA
    ema_fast = data.ewm(span=fast, adjust=False).mean()
    ema_slow = data.ewm(span=slow, adjust=False).mean()

    # MACD Line = 快线 - 慢线
    macd_line = ema_fast - ema_slow

    # Signal Line = MACD Line 的 EMA
    signal_line = macd_line.ewm(span=signal, adjust=False).mean()

    # Histogram = MACD Line - Signal Line
    histogram = macd_line - signal_line

    return pd.DataFrame({
        'MACD': macd_line,
        'Signal': signal_line,
        'Histogram': histogram
    })

# 使用示例
macd = calculate_macd(df['Close'])
df = pd.concat([df, macd], axis=1)

# 交易信号
df['MACD_Signal'] = 0
df.loc[df['MACD'] > df['Signal'], 'MACD_Signal'] = 1   # 看涨
df.loc[df['MACD'] < df['Signal'], 'MACD_Signal'] = -1  # 看跌
```

---

## 📊 布林带 (Bollinger Bands)

```python
def calculate_bollinger_bands(data, window=20, num_std=2):
    """
    计算布林带

    参数:
        data: 价格序列
        window: 窗口期 (默认20)
        num_std: 标准差倍数 (默认2)

    返回:
        DataFrame: Upper Band, Middle Band, Lower Band
    """
    middle_band = data.rolling(window=window).mean()
    std_dev = data.rolling(window=window).std()

    upper_band = middle_band + (std_dev * num_std)
    lower_band = middle_band - (std_dev * num_std)

    return pd.DataFrame({
        'BB_Upper': upper_band,
        'BB_Middle': middle_band,
        'BB_Lower': lower_band
    })

# 使用示例
bb = calculate_bollinger_bands(df['Close'])
df = pd.concat([df, bb], axis=1)

# 交易信号
df['BB_Signal'] = 0
df.loc[df['Close'] > df['BB_Upper'], 'BB_Signal'] = -1  # 超买
df.loc[df['Close'] < df['BB_Lower'], 'BB_Signal'] = 1   # 超卖
```

---

## 🎯 综合策略示例

```python
def generate_trading_signals(df):
    """
    综合多个指标生成交易信号
    """
    signals = []

    for i in range(len(df)):
        score = 0

        # SMA 信号 (权重: 2)
        if df['SMA_20'].iloc[i] > df['SMA_50'].iloc[i]:
            score += 2
        else:
            score -= 2

        # RSI 信号 (权重: 1)
        if df['RSI'].iloc[i] < 30:
            score += 1  # 超卖，看涨
        elif df['RSI'].iloc[i] > 70:
            score -= 1  # 超买，看跌

        # MACD 信号 (权重: 2)
        if df['MACD'].iloc[i] > df['Signal'].iloc[i]:
            score += 2
        else:
            score -= 2

        # 布林带信号 (权重: 1)
        if df['Close'].iloc[i] < df['BB_Lower'].iloc[i]:
            score += 1  # 超卖
        elif df['Close'].iloc[i] > df['BB_Upper'].iloc[i]:
            score -= 1  # 超买

        # 综合判断
        if score >= 4:
            signals.append('Strong Buy')
        elif score >= 2:
            signals.append('Buy')
        elif score <= -4:
            signals.append('Strong Sell')
        elif score <= -2:
            signals.append('Sell')
        else:
            signals.append('Hold')

    df['Combined_Signal'] = signals
    return df

# 应用策略
df = generate_trading_signals(df)
```

---

## 📊 可视化

```python
def plot_indicators(df):
    """可视化技术指标"""
    fig, axes = plt.subplots(4, 1, figsize=(12, 12))

    # 价格和移动平均
    axes[0].plot(df['Close'], label='Price', alpha=0.5)
    axes[0].plot(df['SMA_20'], label='SMA 20')
    axes[0].plot(df['SMA_50'], label='SMA 50')
    axes[0].legend()
    axes[0].set_title('Price & Moving Averages')

    # RSI
    axes[1].plot(df['RSI'], label='RSI')
    axes[1].axhline(y=70, color='r', linestyle='--', alpha=0.5)
    axes[1].axhline(y=30, color='g', linestyle='--', alpha=0.5)
    axes[1].legend()
    axes[1].set_title('RSI')

    # MACD
    axes[2].plot(df['MACD'], label='MACD')
    axes[2].plot(df['Signal'], label='Signal')
    axes[2].bar(df.index, df['Histogram'], label='Histogram', alpha=0.3)
    axes[2].legend()
    axes[2].set_title('MACD')

    # 布林带
    axes[3].plot(df['Close'], label='Price', alpha=0.5)
    axes[3].plot(df['BB_Upper'], label='Upper BB', alpha=0.5)
    axes[3].plot(df['BB_Middle'], label='Middle BB', alpha=0.5)
    axes[3].plot(df['BB_Lower'], label='Lower BB', alpha=0.5)
    axes[3].fill_between(df.index, df['BB_Upper'], df['BB_Lower'], alpha=0.1)
    axes[3].legend()
    axes[3].set_title('Bollinger Bands')

    plt.tight_layout()
    plt.show()

# 绘制图表
plot_indicators(df)
```

---

## 💡 实战建议

### 指标组合
- 不要单独使用任何指标
- 推荐 3-5 个指标组合
- 确认信号：多个指标指向同一方向

### 常见组合
1. **趋势跟踪**: SMA + MACD + 布林带
2. **均值回归**: RSI + 布林带
3. **动量策略**: MACD + RSI

### 风险管理
- 设置止损位
- 控制仓位大小
- 分散投资

---

## 🎓 学习清单

- [x] SMA/EMA 实现
- [x] RSI 实现
- [x] MACD 实现
- [x] 布林带实现
- [x] 综合策略示例
- [ ] 实战: 回测策略
- [ ] 进阶: 优化参数
- [ ] 进阶: 机器学习结合

---

## 📚 参考资源

- Python for Finance
- Technical Analysis Library
- Quantopian Tutorials

---

*学习时长: 25分钟 | 掌握程度: 中级*
*下一步: 回测策略，优化参数*
