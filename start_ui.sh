#!/bin/bash
# AI Toolkit Web UI 启动脚本

# 获取脚本所在目录
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

echo "======================================"
echo "  AI Toolkit Web UI 启动脚本"
echo "======================================"
echo ""

# 检查虚拟环境是否存在
if [ ! -d ".venv" ]; then
    echo "❌ 错误：未找到 .venv 虚拟环境"
    echo "请先运行以下命令创建环境："
    echo "  uv venv"
    echo "  source .venv/bin/activate"
    echo "  uv pip install -r requirements.txt"
    exit 1
fi

# 激活虚拟环境
echo "🔧 激活 Python 虚拟环境..."
source .venv/bin/activate

# 检查是否成功激活
if [ -z "$VIRTUAL_ENV" ]; then
    echo "❌ 错误：虚拟环境激活失败"
    exit 1
fi

echo "✅ Python 环境已激活: $VIRTUAL_ENV"
echo ""

# 检查 Node.js
if ! command -v node &> /dev/null; then
    echo "❌ 错误：未找到 Node.js"
    echo "请先安装 Node.js (版本 > 18)"
    exit 1
fi

echo "📦 Node.js 版本: $(node --version)"
echo ""

# 进入 UI 目录
cd ui

# 检查是否需要安装依赖
if [ ! -d "node_modules" ]; then
    echo "📥 首次运行，正在安装 Node.js 依赖..."
    npm install
    echo ""
fi

# 启动 UI
echo "🚀 启动 AI Toolkit Web UI..."
echo "访问地址: http://localhost:8675"
echo ""
echo "按 Ctrl+C 停止服务"
echo "======================================"
echo ""

npm run build_and_start
