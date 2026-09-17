# HelloAgents智能旅行助手 - 一键启动脚本
# 用法: 在项目根目录执行 .\start.ps1 (或双击 start.bat)
# 流程参考 README.md: 启动后端(FastAPI, 端口8000) + 前端(Vite, 端口5173)

$ErrorActionPreference = "Stop"
$Root = $PSScriptRoot
$BackendDir = Join-Path $Root "backend"
$FrontendDir = Join-Path $Root "frontend"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  HelloAgents 智能旅行助手 启动脚本" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# 本机Node.js可能不在PATH中(见 环境配置.txt),尝试补充
if (-not (Get-Command node -ErrorAction SilentlyContinue)) {
    $nodePath = "C:\Program Files\nodejs"
    if (Test-Path $nodePath) {
        $env:Path += ";$nodePath"
        Write-Host "[提示] 已将 $nodePath 加入本次会话PATH" -ForegroundColor Yellow
    }
}

# ============ 环境检查 ============
Write-Host "[1/5] 环境检查..." -ForegroundColor Green

if (-not (Get-Command node -ErrorAction SilentlyContinue)) {
    Write-Host "[错误] 未找到 Node.js,请先安装 Node.js 16+" -ForegroundColor Red
    exit 1
}
Write-Host "  Node.js: $(node --version)"

if (-not (Get-Command python -ErrorAction SilentlyContinue)) {
    Write-Host "[错误] 未找到 Python,请先安装 Python 3.10+" -ForegroundColor Red
    exit 1
}
Write-Host "  Python: $(python --version)"

# 检查环境变量配置
if (-not (Test-Path (Join-Path $BackendDir ".env"))) {
    Write-Host "[错误] 后端缺少 .env 文件,请参考 backend\.env.example 配置API密钥" -ForegroundColor Red
    exit 1
}
if (-not (Test-Path (Join-Path $FrontendDir ".env"))) {
    Write-Host "[错误] 前端缺少 .env 文件,请参考 frontend\.env.example 配置高德地图Key" -ForegroundColor Red
    exit 1
}
Write-Host "  .env 配置文件: 已就绪"

# ============ 后端准备 ============
Write-Host "[2/5] 准备后端环境..." -ForegroundColor Green

$VenvPython = Join-Path $BackendDir "venv\Scripts\python.exe"

# 创建虚拟环境(如不存在)
if (-not (Test-Path $VenvPython)) {
    Write-Host "  创建虚拟环境..."
    Push-Location $BackendDir
    python -m venv venv
    Pop-Location
}

# 安装依赖(如缺少fastapi则视为未安装)
$VenvPip = Join-Path $BackendDir "venv\Scripts\pip.exe"
& $VenvPip show fastapi *> $null
if ($LASTEXITCODE -ne 0) {
    Write-Host "  安装后端依赖(首次安装需几分钟)..."
    & $VenvPip install -r (Join-Path $BackendDir "requirements.txt") -q
    if ($LASTEXITCODE -ne 0) {
        Write-Host "[错误] 后端依赖安装失败" -ForegroundColor Red
        exit 1
    }
}
Write-Host "  后端依赖: 已就绪"

# ============ 前端准备 ============
Write-Host "[3/5] 准备前端环境..." -ForegroundColor Green

if (-not (Test-Path (Join-Path $FrontendDir "node_modules"))) {
    Write-Host "  安装前端依赖(首次安装需几分钟)..."
    Push-Location $FrontendDir
    npm install
    Pop-Location
    if ($LASTEXITCODE -ne 0) {
        Write-Host "[错误] 前端依赖安装失败" -ForegroundColor Red
        exit 1
    }
}
Write-Host "  前端依赖: 已就绪"

# ============ 启动服务 ============
Write-Host "[4/5] 启动服务..." -ForegroundColor Green

# 启动后端: uvicorn app.api.main:app --reload --host 0.0.0.0 --port 8000
Write-Host "  启动后端 (http://localhost:8000, API文档: http://localhost:8000/docs)..."
Start-Process powershell -ArgumentList "-NoExit", "-Command", `
    "Set-Location '$BackendDir'; & '$VenvPython' -m uvicorn app.api.main:app --reload --host 0.0.0.0 --port 8000"

# 启动前端: npm run dev
Write-Host "  启动前端 (http://localhost:5173)..."
Start-Process powershell -ArgumentList "-NoExit", "-Command", `
    "Set-Location '$FrontendDir'; npm run dev"

# ============ 打开浏览器 ============
Write-Host "[5/5] 等待服务就绪后打开浏览器..." -ForegroundColor Green
Start-Sleep -Seconds 5
Start-Process "http://localhost:5173"

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  启动完成!" -ForegroundColor Cyan
Write-Host "  前端: http://localhost:5173" -ForegroundColor Cyan
Write-Host "  后端: http://localhost:8000/docs" -ForegroundColor Cyan
Write-Host "  关闭服务: 直接关闭弹出的两个后端/前端窗口" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
