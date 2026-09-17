<template>
  <div class="home-container">
    <!-- 携程式蓝色渐变头图 -->
    <div class="hero">
      <div class="hero-inner">
        <h1 class="hero-title">智能旅行助手</h1>
        <p class="hero-subtitle">基于多智能体的个性化旅行规划，让每一次出行都完美无忧</p>
      </div>
      <!-- 装饰光斑 -->
      <div class="hero-glow glow-1"></div>
      <div class="hero-glow glow-2"></div>
    </div>

    <!-- 表单卡:上浮与头图衔接,携程搜索卡式样 -->
    <div class="form-card">
      <a-form
        :model="formData"
        layout="vertical"
        @finish="handleSubmit"
      >
        <!-- 第一步:目的地和日期 -->
        <div class="form-section">
          <div class="section-header">
            <span class="section-title">目的地与日期</span>
          </div>

          <a-row :gutter="24">
            <a-col :span="8">
              <a-form-item name="city" :rules="[{ required: true, message: '请输入目的地城市' }]">
                <template #label>
                  <span class="form-label">目的地城市</span>
                </template>
                <a-input
                  v-model:value="formData.city"
                  placeholder="例如: 北京"
                  size="large"
                  class="custom-input"
                >
                  <template #prefix>
                    <span style="color: #1E5EFF;">🏙️</span>
                  </template>
                </a-input>
              </a-form-item>
            </a-col>
            <a-col :span="6">
              <a-form-item name="start_date" :rules="[{ required: true, message: '请选择开始日期' }]">
                <template #label>
                  <span class="form-label">开始日期</span>
                </template>
                <a-date-picker
                  v-model:value="formData.start_date"
                  style="width: 100%"
                  size="large"
                  class="custom-input"
                  placeholder="选择日期"
                />
              </a-form-item>
            </a-col>
            <a-col :span="6">
              <a-form-item name="end_date" :rules="[{ required: true, message: '请选择结束日期' }]">
                <template #label>
                  <span class="form-label">结束日期</span>
                </template>
                <a-date-picker
                  v-model:value="formData.end_date"
                  style="width: 100%"
                  size="large"
                  class="custom-input"
                  placeholder="选择日期"
                />
              </a-form-item>
            </a-col>
            <a-col :span="4">
              <a-form-item>
                <template #label>
                  <span class="form-label">旅行天数</span>
                </template>
                <div class="days-display-compact">
                  <span class="days-value">{{ formData.travel_days }}</span>
                  <span class="days-unit">天</span>
                </div>
              </a-form-item>
            </a-col>
          </a-row>
        </div>

        <!-- 第二步:偏好设置 -->
        <div class="form-section">
          <div class="section-header">
            <span class="section-title">偏好设置</span>
          </div>

          <a-row :gutter="24">
            <a-col :span="8">
              <a-form-item name="transportation">
                <template #label>
                  <span class="form-label">交通方式</span>
                </template>
                <a-select v-model:value="formData.transportation" size="large" class="custom-select">
                  <a-select-option value="公共交通">🚇 公共交通</a-select-option>
                  <a-select-option value="自驾">🚗 自驾</a-select-option>
                  <a-select-option value="步行">🚶 步行</a-select-option>
                  <a-select-option value="混合">🔀 混合</a-select-option>
                </a-select>
              </a-form-item>
            </a-col>
            <a-col :span="8">
              <a-form-item name="accommodation">
                <template #label>
                  <span class="form-label">住宿偏好</span>
                </template>
                <a-select v-model:value="formData.accommodation" size="large" class="custom-select">
                  <a-select-option value="经济型酒店">💰 经济型酒店</a-select-option>
                  <a-select-option value="舒适型酒店">🏨 舒适型酒店</a-select-option>
                  <a-select-option value="豪华酒店">⭐ 豪华酒店</a-select-option>
                  <a-select-option value="民宿">🏡 民宿</a-select-option>
                </a-select>
              </a-form-item>
            </a-col>
            <a-col :span="8">
              <a-form-item name="preferences">
                <template #label>
                  <span class="form-label">旅行偏好</span>
                </template>
                <div class="preference-tags">
                  <a-checkbox-group v-model:value="formData.preferences" class="custom-checkbox-group">
                    <a-checkbox value="历史文化" class="preference-tag">🏛️ 历史文化</a-checkbox>
                    <a-checkbox value="自然风光" class="preference-tag">🏞️ 自然风光</a-checkbox>
                    <a-checkbox value="美食" class="preference-tag">🍜 美食</a-checkbox>
                    <a-checkbox value="购物" class="preference-tag">🛍️ 购物</a-checkbox>
                    <a-checkbox value="艺术" class="preference-tag">🎨 艺术</a-checkbox>
                    <a-checkbox value="休闲" class="preference-tag">☕ 休闲</a-checkbox>
                  </a-checkbox-group>
                </div>
              </a-form-item>
            </a-col>
          </a-row>
        </div>

        <!-- 第三步:额外要求 -->
        <div class="form-section">
          <div class="section-header">
            <span class="section-title">额外要求</span>
          </div>

          <a-form-item name="free_text_input">
            <a-textarea
              v-model:value="formData.free_text_input"
              placeholder="请输入您的额外要求,例如:想去看升旗、需要无障碍设施、对海鲜过敏等..."
              :rows="3"
              size="large"
              class="custom-textarea"
            />
          </a-form-item>
        </div>

        <!-- 提交按钮 -->
        <a-form-item>
          <a-button
            type="primary"
            html-type="submit"
            :loading="loading"
            size="large"
            block
            class="submit-button"
          >
            <template v-if="!loading">
              <span>开始规划我的旅行</span>
            </template>
            <template v-else>
              <span>正在生成中...</span>
            </template>
          </a-button>
        </a-form-item>

        <!-- 加载进度条 -->
        <a-form-item v-if="loading">
          <div class="loading-container">
            <a-progress
              :percent="loadingProgress"
              status="active"
              :stroke-color="{
                '0%': '#3D7EFF',
                '100%': '#1E5EFF',
              }"
              :stroke-width="10"
            />
            <p class="loading-status">
              {{ loadingStatus }}
            </p>
          </div>
        </a-form-item>
      </a-form>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive, watch } from 'vue'
import { useRouter } from 'vue-router'
import { message } from 'ant-design-vue'
import { generateTripPlan } from '@/services/api'
import type { TripFormData } from '@/types'
import type { Dayjs } from 'dayjs'

const router = useRouter()
const loading = ref(false)
const loadingProgress = ref(0)
const loadingStatus = ref('')

type TripFormState = Omit<TripFormData, 'start_date' | 'end_date'> & {
  start_date: Dayjs | null
  end_date: Dayjs | null
}

const formData = reactive<TripFormState>({
  city: '',
  start_date: null,
  end_date: null,
  travel_days: 1,
  transportation: '公共交通',
  accommodation: '经济型酒店',
  preferences: [],
  free_text_input: ''
})

// 监听日期变化,自动计算旅行天数
watch([() => formData.start_date, () => formData.end_date], ([start, end]) => {
  if (start && end) {
    const days = end.diff(start, 'day') + 1
    if (days > 0 && days <= 30) {
      formData.travel_days = days
    } else if (days > 30) {
      message.warning('旅行天数不能超过30天')
      formData.end_date = null
    } else {
      message.warning('结束日期不能早于开始日期')
      formData.end_date = null
    }
  }
})

const handleSubmit = async () => {
  if (!formData.start_date || !formData.end_date) {
    message.error('请选择日期')
    return
  }

  loading.value = true
  loadingProgress.value = 0
  loadingStatus.value = '正在初始化...'

  // 模拟进度更新
  const progressInterval = setInterval(() => {
    if (loadingProgress.value < 90) {
      loadingProgress.value += 10

      // 更新状态文本
      if (loadingProgress.value <= 30) {
        loadingStatus.value = '🔍 正在搜索景点...'
      } else if (loadingProgress.value <= 50) {
        loadingStatus.value = '🌤️ 正在查询天气...'
      } else if (loadingProgress.value <= 70) {
        loadingStatus.value = '🏨 正在推荐酒店...'
      } else {
        loadingStatus.value = '📋 正在生成行程计划...'
      }
    } else if (loadingProgress.value === 90) {
      loadingStatus.value = '⏳ 行程生成通常需要3-5分钟,请耐心等待...'
    }
  }, 500)

  try {
    const requestData: TripFormData = {
      city: formData.city,
      start_date: formData.start_date.format('YYYY-MM-DD'),
      end_date: formData.end_date.format('YYYY-MM-DD'),
      travel_days: formData.travel_days,
      transportation: formData.transportation,
      accommodation: formData.accommodation,
      preferences: formData.preferences,
      free_text_input: formData.free_text_input
    }

    const response = await generateTripPlan(requestData)

    clearInterval(progressInterval)
    loadingProgress.value = 100
    loadingStatus.value = '✅ 完成!'

    if (response.success && response.data) {
      // 保存到sessionStorage
      sessionStorage.setItem('tripPlan', JSON.stringify(response.data))

      message.success('旅行计划生成成功!')

      // 短暂延迟后跳转
      setTimeout(() => {
        router.push('/result')
      }, 500)
    } else {
      message.error(response.message || '生成失败')
    }
  } catch (error: any) {
    clearInterval(progressInterval)
    message.error(error.message || '生成旅行计划失败,请稍后重试')
  } finally {
    setTimeout(() => {
      loading.value = false
      loadingProgress.value = 0
      loadingStatus.value = ''
    }, 1000)
  }
}
</script>

<style scoped>
/* 携程风格:浅灰页面底 + 蓝色渐变头图 + 白色表单卡 */
.home-container {
  min-height: calc(100vh - 56px);
  background: #f5f6f7;
  padding-bottom: 80px;
  position: relative;
}

/* 蓝色渐变头图 */
.hero {
  position: relative;
  background: linear-gradient(135deg, #2b6de8 0%, #1e5eff 55%, #3d7eff 100%);
  padding: 90px 20px 110px;
  overflow: hidden;
}

.hero-inner {
  max-width: 1400px;
  margin: 0 auto;
  position: relative;
  z-index: 1;
  text-align: center;
  animation: fadeInDown 0.7s ease-out;
}

.hero-title {
  margin: 0 0 14px;
  font-size: 44px;
  font-weight: 800;
  color: #ffffff;
  letter-spacing: 4px;
}

.hero-subtitle {
  margin: 0;
  font-size: 17px;
  color: rgba(255, 255, 255, 0.85);
  letter-spacing: 1px;
}

/* 头图装饰光斑 */
.hero-glow {
  position: absolute;
  border-radius: 50%;
  background: rgba(255, 255, 255, 0.08);
  pointer-events: none;
}

.glow-1 {
  width: 420px;
  height: 420px;
  top: -160px;
  right: -100px;
}

.glow-2 {
  width: 280px;
  height: 280px;
  bottom: -120px;
  left: -80px;
}

/* 表单卡:上浮衔接头图(携程搜索卡式样) */
.form-card {
  max-width: 1400px;
  margin: -70px auto 0;
  padding: 28px 32px 24px;
  background: #ffffff;
  border-radius: 12px;
  box-shadow: 0 8px 24px rgba(30, 94, 255, 0.1);
  animation: fadeInUp 0.7s ease-out;
  position: relative;
  z-index: 2;
}

/* 表单分区 */
.form-section {
  margin-bottom: 24px;
  padding: 20px 24px;
  background: #ffffff;
  border-radius: 10px;
  border: 1px solid #eef1f6;
  transition: box-shadow 0.3s ease;
}

.form-section:hover {
  box-shadow: 0 4px 16px rgba(30, 94, 255, 0.08);
}

.section-header {
  display: flex;
  align-items: center;
  margin-bottom: 18px;
  padding-bottom: 10px;
  border-bottom: 2px solid #1e5eff;
}

/* 携程式小竖条+标题 */
.section-header::before {
  content: '';
  width: 4px;
  height: 18px;
  background: #1e5eff;
  border-radius: 2px;
  margin-right: 10px;
}

.section-title {
  font-size: 17px;
  font-weight: 700;
  color: #1a1a1a;
}

/* 表单标签 */
.form-label {
  font-size: 14px;
  font-weight: 600;
  color: #333;
}

/* 输入框: 携程蓝色聚焦 */
.custom-input :deep(.ant-input),
.custom-input :deep(.ant-picker) {
  border-radius: 8px;
  border: 1.5px solid #e3e8ef;
  transition: all 0.25s ease;
}

.custom-input :deep(.ant-input:hover),
.custom-input :deep(.ant-picker:hover) {
  border-color: #1e5eff;
}

.custom-input :deep(.ant-input:focus),
.custom-input :deep(.ant-picker-focused) {
  border-color: #1e5eff;
  box-shadow: 0 0 0 3px rgba(30, 94, 255, 0.12);
}

/* 选择框 */
.custom-select :deep(.ant-select-selector) {
  border-radius: 8px !important;
  border: 1.5px solid #e3e8ef !important;
  transition: all 0.25s ease;
}

.custom-select:hover :deep(.ant-select-selector) {
  border-color: #1e5eff !important;
}

.custom-select :deep(.ant-select-focused .ant-select-selector) {
  border-color: #1e5eff !important;
  box-shadow: 0 0 0 3px rgba(30, 94, 255, 0.12) !important;
}

/* 天数显示: 携程蓝底 */
.days-display-compact {
  display: flex;
  align-items: center;
  justify-content: center;
  height: 40px;
  padding: 8px 16px;
  background: linear-gradient(135deg, #3d7eff 0%, #1e5eff 100%);
  border-radius: 8px;
  color: white;
}

.days-display-compact .days-value {
  font-size: 22px;
  font-weight: 700;
  margin-right: 4px;
}

.days-display-compact .days-unit {
  font-size: 13px;
}

/* 偏好标签: 选中携程蓝 */
.preference-tags {
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
}

.custom-checkbox-group {
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
  width: 100%;
}

.preference-tag :deep(.ant-checkbox-wrapper) {
  margin: 0 !important;
  padding: 7px 14px;
  border: 1.5px solid #e3e8ef;
  border-radius: 18px;
  transition: all 0.25s ease;
  background: white;
  font-size: 13px;
  color: #333;
}

.preference-tag :deep(.ant-checkbox-wrapper:hover) {
  border-color: #1e5eff;
  color: #1e5eff;
  background: #edf3ff;
}

.preference-tag :deep(.ant-checkbox-wrapper-checked) {
  border-color: #1e5eff;
  background: #1e5eff;
  color: white;
}

/* 文本域 */
.custom-textarea :deep(.ant-input) {
  border-radius: 8px;
  border: 1.5px solid #e3e8ef;
  transition: all 0.25s ease;
}

.custom-textarea :deep(.ant-input:hover) {
  border-color: #1e5eff;
}

.custom-textarea :deep(.ant-input:focus) {
  border-color: #1e5eff;
  box-shadow: 0 0 0 3px rgba(30, 94, 255, 0.12);
}

/* 提交按钮: 携程蓝色渐变大按钮 */
.submit-button {
  height: 54px;
  border-radius: 8px;
  font-size: 18px;
  font-weight: 700;
  letter-spacing: 2px;
  background: linear-gradient(135deg, #3d7eff 0%, #1e5eff 100%);
  border: none;
  box-shadow: 0 6px 18px rgba(30, 94, 255, 0.35);
  transition: all 0.25s ease;
}

.submit-button:hover {
  background: linear-gradient(135deg, #2b6de8 0%, #1554d6 100%) !important;
  transform: translateY(-1px);
  box-shadow: 0 10px 24px rgba(30, 94, 255, 0.45);
}

.submit-button:active {
  transform: translateY(0);
}

/* 加载容器 */
.loading-container {
  text-align: center;
  padding: 24px;
  background: #f5f8ff;
  border-radius: 10px;
  border: 1.5px dashed #1e5eff;
}

.loading-status {
  margin: 14px 0 0;
  color: #1e5eff;
  font-size: 15px;
  font-weight: 600;
}

/* 动画 */
@keyframes fadeInDown {
  from {
    opacity: 0;
    transform: translateY(-24px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

@keyframes fadeInUp {
  from {
    opacity: 0;
    transform: translateY(24px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

@media (max-width: 768px) {
  .hero {
    padding: 56px 16px 90px;
  }

  .hero-title {
    font-size: 30px;
  }
}
</style>
