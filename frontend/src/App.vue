<template>
  <div id="app">
    <!-- 携程风格顶栏: 白底 + 蓝色Logo -->
    <header class="site-header">
      <div class="header-inner">
        <div class="logo" @click="$router.push('/')">
          <span class="logo-icon">✈️</span>
          <span class="logo-text">HelloAgents<em>旅行</em></span>
        </div>
        <nav class="header-nav">
          <span class="nav-item active">行程规划</span>
          <span class="nav-item">多智能体驱动</span>
        </nav>
      </div>
    </header>

    <main class="site-main">
      <router-view />
    </main>

    <footer class="site-footer">
      HelloAgents智能旅行助手 ©2025 · 基于HelloAgents多智能体框架
    </footer>
  </div>
</template>

<script setup lang="ts">
</script>

<style>
:root {
  /* 携程风格配色 */
  --ctrip-blue: #1E5EFF;
  --ctrip-blue-light: #3D7EFF;
  --ctrip-blue-deep: #2B6DE8;
  --ctrip-orange: #FF4400;
  --ctrip-bg: #F5F6F7;
  --ctrip-ink: #1A1A1A;
  --ctrip-sub: #666666;
  --blue-wash: #EDF3FF;
}

* {
  box-sizing: border-box;
}

html,
body {
  margin: 0;
  padding: 0;
}

#app {
  min-height: 100vh;
  display: flex;
  flex-direction: column;
  background: var(--ctrip-bg);
  font-family: -apple-system, BlinkMacSystemFont, 'PingFang SC', 'Microsoft YaHei',
    'Helvetica Neue', Arial, sans-serif;
  color: var(--ctrip-ink);
}

/* 顶栏 */
.site-header {
  position: sticky;
  top: 0;
  z-index: 100;
  background: #ffffff;
  box-shadow: 0 1px 0 rgba(0, 0, 0, 0.06);
}

.header-inner {
  max-width: 1400px;
  margin: 0 auto;
  height: 56px;
  padding: 0 24px;
  display: flex;
  align-items: center;
  justify-content: space-between;
}

.logo {
  display: flex;
  align-items: center;
  gap: 8px;
  cursor: pointer;
  user-select: none;
}

.logo-icon {
  font-size: 24px;
}

.logo-text {
  font-size: 22px;
  font-weight: 800;
  color: var(--ctrip-blue);
  letter-spacing: 1px;
}

.logo-text em {
  font-style: normal;
  color: var(--ctrip-orange);
}

.header-nav {
  display: flex;
  gap: 28px;
}

.nav-item {
  font-size: 14px;
  color: var(--ctrip-sub);
  cursor: pointer;
  transition: color 0.2s;
}

.nav-item:hover {
  color: var(--ctrip-blue);
}

.nav-item.active {
  color: var(--ctrip-blue);
  font-weight: 600;
}

/* 主内容与页脚 */
.site-main {
  flex: 1;
}

.site-footer {
  text-align: center;
  padding: 20px;
  font-size: 12px;
  color: #999;
}

/* 全局滚动条 */
::-webkit-scrollbar {
  width: 8px;
}

::-webkit-scrollbar-thumb {
  background: #d4d9e0;
  border-radius: 4px;
}

::-webkit-scrollbar-thumb:hover {
  background: #b8bfc8;
}

::-webkit-scrollbar-track {
  background: transparent;
}
</style>
