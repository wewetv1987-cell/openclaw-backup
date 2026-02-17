#!/usr/bin/env python3
"""
数据格式转换模板
支持: CSV, JSON, Excel, YAML 互转
"""

import argparse
import json
import sys
from pathlib import Path

try:
    import pandas as pd
except ImportError:
    print("❌ 请安装 pandas: pip install pandas openpyxl pyyaml")
    sys.exit(1)

SUPPORTED_FORMATS = ['csv', 'json', 'xlsx', 'yaml', 'parquet']

def detect_format(filepath: str) -> str:
    """根据文件扩展名检测格式"""
    ext = Path(filepath).suffix.lower().lstrip('.')
    if ext in ['xls', 'xlsx']:
        return 'xlsx'
    if ext in ['yml', 'yaml']:
        return 'yaml'
    return ext if ext in SUPPORTED_FORMATS else None

def read_file(filepath: str, fmt: str = None) -> pd.DataFrame:
    """读取文件到 DataFrame"""
    if fmt is None:
        fmt = detect_format(filepath)
    
    readers = {
        'csv': pd.read_csv,
        'json': pd.read_json,
        'xlsx': pd.read_excel,
        'yaml': lambda f: pd.DataFrame(pd.read_yaml(f)),
        'parquet': pd.read_parquet,
    }
    
    if fmt not in readers:
        raise ValueError(f"不支持的格式: {fmt}")
    
    return readers[fmt](filepath)

def write_file(df: pd.DataFrame, filepath: str, fmt: str = None):
    """写入 DataFrame 到文件"""
    if fmt is None:
        fmt = detect_format(filepath)
    
    writers = {
        'csv': df.to_csv,
        'json': lambda f: df.to_json(f, orient='records', indent=2, force_ascii=False),
        'xlsx': df.to_excel,
        'yaml': lambda f: df.to_yaml(f),
        'parquet': df.to_parquet,
    }
    
    if fmt not in writers:
        raise ValueError(f"不支持的格式: {fmt}")
    
    if fmt == 'csv':
        writers[fmt](filepath, index=False)
    elif fmt == 'xlsx':
        writers[fmt](filepath, index=False, engine='openpyxl')
    else:
        writers[fmt](filepath)

def convert(input_file: str, output_file: str, input_fmt: str = None, output_fmt: str = None):
    """执行转换"""
    print(f"📥 读取: {input_file}")
    df = read_file(input_file, input_fmt)
    print(f"📊 数据: {len(df)} 行, {len(df.columns)} 列")
    
    print(f"📤 写入: {output_file}")
    write_file(df, output_file, output_fmt)
    print("✅ 转换完成")

def main():
    parser = argparse.ArgumentParser(description='数据格式转换工具')
    parser.add_argument('input', help='输入文件')
    parser.add_argument('output', help='输出文件')
    parser.add_argument('--ifmt', help='输入格式 (自动检测)')
    parser.add_argument('--ofmt', help='输出格式 (自动检测)')
    
    args = parser.parse_args()
    convert(args.input, args.output, args.ifmt, args.ofmt)

if __name__ == '__main__':
    main()
