# HelloAgents智能旅行助手 🌍✈️

基于 HelloAgents 框架构建的智能旅行规划助手，集成高德地图 MCP 服务，提供个性化的旅行计划生成。

## ✨ 功能特点

- 🤖 **AI驱动的旅行规划**：基于 HelloAgents 框架的 SimpleAgent，智能生成详细的多日旅程
- 🗺️ **高德地图集成**：通过 MCP 协议接入高德地图服务，支持景点搜索、路线规划、天气查询
- 🧠 **智能工具调用**：Agent 自动调用高德地图 MCP 工具，获取实时 POI、路线和天气信息
- 🖼️ **目的地美图**：集成 Unsplash API，为目的地展示高质量实景图片
- 🎨 **现代化前端**：Vue3 + TypeScript + Vite，响应式设计，流畅的用户体验
- 📱 **完整功能**：包含住宿、交通、餐饮和景点游览时间推荐

## 🏗️ 技术栈

### 后端
- **框架**：HelloAgents（基于 SimpleAgent）
- **API**：FastAPI
- **MCP工具**：amap-mcp-server（高德地图）
- **LLM**：支持多种 LLM 提供商（Moonshot Kimi、OpenAI、DeepSeek 等）
- **图片服务**：Unsplash API

### 前端
- **框架**：Vue 3 + TypeScript
- **构建工具**：Vite
- **UI组件库**：Ant Design Vue
- **地图服务**：高德地图 JavaScript API
- **HTTP客户端**：Axios

## 📁 项目结构

```
helloagents-trip-planner/
├── backend/                    # 后端服务
│   ├── app/
│   │   ├── agents/            # Agent实现
│   │   │   └── trip_planner_agent.py
│   │   ├── api/               # FastAPI路由
│   │   │   ├── main.py
│   │   │   └── routes/
│   │   │       ├── trip.py    # 旅行计划生成
│   │   │       ├── map.py     # 地图相关
│   │   │       └── poi.py     # POI搜索
│   │   ├── services/          # 服务层
│   │   │   ├── amap_service.py        # 高德地图服务
│   │   │   ├── llm_service.py         # LLM服务
│   │   │   └── unsplash_service.py    # Unsplash图片服务
│   │   ├── models/            # 数据模型
│   │   │   └── schemas.py
│   │   └── config.py          # 配置管理
│   ├── requirements.txt
│   └── .env.example
├── frontend/                   # 前端应用
│   ├── src/
│   │   ├── components/        # Vue组件
│   │   ├── services/          # API服务
│   │   ├── types/             # TypeScript类型
│   │   └── views/             # 页面视图（Home / Result）
│   ├── package.json
│   └── vite.config.ts
├── start.bat / start.ps1       # Windows一键启动脚本
├── glm-4.7-flash-free.py       # GLM模型连通性测试脚本
└── kimi-k2.6.py                # Kimi模型连通性测试脚本
```

## 🚀 快速开始

### 前提条件

- Python 3.10+
- Node.js 16+
- 高德地图 API 密钥（Web服务 API 和 Web端 JS API），[申请地址](https://lbs.amap.com/)
- LLM API 密钥（Moonshot Kimi / OpenAI / DeepSeek 等）
- Unsplash API 密钥（[申请地址](https://unsplash.com/developers)）

### Windows 一键启动（推荐）

```powershell
.\start.ps1     # 或直接双击 start.bat
```

脚本会自动完成环境检查、依赖准备，并同时启动后端（端口 8000）和前端（端口 5173）。

### 手动启动

#### 后端

1. 创建虚拟环境并安装依赖
```bash
cd backend
python -m venv venv
source venv/bin/activate  # Windows: venv\Scripts\activate
pip install -r requirements.txt
```

2. 配置环境变量
```bash
cp .env.example .env
# 编辑 .env 文件，填入你的 LLM / 高德地图 / Unsplash API 密钥
```

3. 启动后端服务
```bash
uvicorn app.api.main:app --reload --host 0.0.0.0 --port 8000
```

#### 前端

1. 安装依赖
```bash
cd frontend
npm install
```

2. 配置环境变量
```bash
cp .env.example .env
# 编辑 .env 文件，填入高德地图 Web API Key 和 Web端 JS API Key
```

3. 启动开发服务器
```bash
npm run dev
```

4. 打开浏览器访问 `http://localhost:5173`

## 📝 使用指南

1. 在首页填写旅行信息：
   - 目的地城市
   - 旅行日期和天数
   - 交通方式偏好
   - 住宿偏好
   - 旅行风格标签

2. 点击"生成旅行计划"按钮

3. 系统将：
   - 调用 HelloAgents Agent 生成初步计划
   - Agent 自动调用高德地图 MCP 工具搜索景点
   - Agent 获取天气信息和路线规划
   - 整合所有信息生成完整行程

4. 查看结果：
   - 每日详细行程
   - 景点信息与地图标记
   - 交通路线规划
   - 天气预报
   - 餐饮推荐

## 🔧 核心实现

### HelloAgents Agent集成

```python
from hello_agents import SimpleAgent, HelloAgentsLLM
from hello_agents.tools import MCPTool

# 创建高德地图MCP工具
amap_tool = MCPTool(
    name="amap",
    server_command=["uvx", "amap-mcp-server"],
    env={"AMAP_MAPS_API_KEY": "your_api_key"},
    auto_expand=True
)

# 创建旅行规划Agent
agent = SimpleAgent(
    name="旅行规划助手",
    llm=HelloAgentsLLM(),
    system_prompt="你是一个专业的旅行规划助手..."
)

# 添加工具
agent.add_tool(amap_tool)
```

### MCP工具调用

Agent 可以自动调用以下高德地图 MCP 工具：
- `maps_text_search`：搜索景点POI
- `maps_weather`：查询天气
- `maps_direction_walking_by_address`：步行路线规划
- `maps_direction_driving_by_address`：驾车路线规划
- `maps_direction_transit_integrated_by_address`：公共交通路线规划

## 📄 API文档

启动后端服务后，访问 `http://localhost:8000/docs` 查看完整的 API 文档（Swagger UI）。

## 🤝 贡献指南

欢迎提交 Pull Request 或 Issue！

## 📜 开源协议

CC BY-NC-SA 4.0

## 🙏 致谢

- [HelloAgents](https://github.com/datawhalechina/Hello-Agents) - 智能体教程
- [HelloAgents框架](https://github.com/jjyaoao/HelloAgents) - 智能体框架
- [高德地图开放平台](https://lbs.amap.com/) - 地图服务
- [amap-mcp-server](https://github.com/sugarforever/amap-mcp-server) - 高德地图MCP服务器
- [Unsplash](https://unsplash.com/) - 图片服务

---

**HelloAgents智能旅行助手** - 让旅行计划变得简单而智能 🌈
