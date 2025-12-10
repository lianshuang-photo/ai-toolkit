@echo off
REM AI Toolkit Web UI 启动脚本 (Windows)

cd /d "%~dp0"

echo ======================================
echo   AI Toolkit Web UI 启动脚本
echo ======================================
echo.

REM 检查虚拟环境是否存在
if not exist ".venv" (
    echo ❌ 错误：未找到 .venv 虚拟环境
    echo 请先运行以下命令创建环境：
    echo   uv venv
    echo   .venv\Scripts\activate
    echo   uv pip install -r requirements.txt
    pause
    exit /b 1
)

REM 激活虚拟环境
echo 🔧 激活 Python 虚拟环境...
call .venv\Scripts\activate.bat

if errorlevel 1 (
    echo ❌ 错误：虚拟环境激活失败
    pause
    exit /b 1
)

echo ✅ Python 环境已激活
echo.

REM 检查 Node.js
where node >nul 2>nul
if errorlevel 1 (
    echo ❌ 错误：未找到 Node.js
    echo 请先安装 Node.js (版本 ^> 18^)
    pause
    exit /b 1
)

echo 📦 Node.js 版本:
node --version
echo.

REM 进入 UI 目录
cd ui

REM 检查是否需要安装依赖
if not exist "node_modules" (
    echo 📥 首次运行，正在安装 Node.js 依赖...
    npm install
    echo.
)

REM 启动 UI
echo 🚀 启动 AI Toolkit Web UI...
echo 访问地址: http://localhost:8675
echo.
echo 按 Ctrl+C 停止服务
echo ======================================
echo.

npm run build_and_start
