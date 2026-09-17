"""LLM服务模块"""

import os
import re
import time
from typing import Iterator

from hello_agents import HelloAgentsLLM

# 全局LLM实例
_llm_instance = None

# 429限流最大重试次数
MAX_RATE_LIMIT_RETRIES = 6

# 是否关闭kimi思考模式(大幅加快生成速度)
_DISABLE_THINKING = os.getenv("LLM_DISABLE_THINKING", "").lower() in ("1", "true", "yes", "disabled")


class RateLimitRetryLLM:
    """带429限流自动重试的LLM包装器

    Moonshot免费账户有RPM限制,多智能体流程会连续发起请求,
    触发429时按服务端提示的等待时间自动重试。
    同时注入extra_body以关闭kimi思考模式。
    """

    def __init__(self, llm: HelloAgentsLLM):
        self._llm = llm

    def _get_retry_wait(self, error: Exception) -> float:
        """从429错误消息中解析建议等待时间(秒),失败则用指数退避"""
        msg = str(error)
        match = re.search(r'try again after (\d+)', msg)
        if match:
            return int(match.group(1)) + 1
        return 15

    def invoke(self, messages, **kwargs) -> str:
        # 关闭kimi思考模式,避免长时间等待推理输出
        if _DISABLE_THINKING:
            kwargs.setdefault("extra_body", {"thinking": {"type": "disabled"}})

        last_error = None
        for attempt in range(MAX_RATE_LIMIT_RETRIES):
            try:
                return self._llm.invoke(messages, **kwargs)
            except Exception as e:
                if '429' in str(e) or 'rate_limit' in str(e) or 'RateLimit' in type(e).__name__:
                    wait = self._get_retry_wait(e)
                    print(f"⏳ LLM请求被限流(第{attempt + 1}次重试),等待{wait}秒...")
                    time.sleep(wait)
                    last_error = e
                else:
                    raise
        raise last_error

    def stream_invoke(self, messages, **kwargs) -> Iterator[str]:
        yield from self._llm.stream_invoke(messages, **kwargs)

    def think(self, messages, temperature=None, **kwargs) -> Iterator[str]:
        yield from self._llm.think(messages, temperature, **kwargs)

    def __getattr__(self, name):
        return getattr(self._llm, name)


def get_llm() -> HelloAgentsLLM:
    """
    获取LLM实例(单例模式)

    Returns:
        HelloAgentsLLM实例
    """
    global _llm_instance

    if _llm_instance is None:
        # 显式指定provider和凭据,避免自动检测被系统环境变量
        # (如DASHSCOPE_API_KEY)干扰而误判提供商,导致401认证失败
        # kimi-k2.6对temperature有强制要求: 思考模式开启必须为1,关闭必须为0.6
        default_temp = "0.6" if _DISABLE_THINKING else "1"
        llm = HelloAgentsLLM(
            model=os.getenv("LLM_MODEL_ID"),
            api_key=os.getenv("LLM_API_KEY"),
            base_url=os.getenv("LLM_BASE_URL"),
            provider="custom",
            temperature=float(os.getenv("LLM_TEMPERATURE", default_temp)),
            timeout=int(os.getenv("LLM_TIMEOUT", "300")),
        )

        print(f"✅ LLM服务初始化成功")
        print(f"   提供商: {llm.provider}")
        print(f"   模型: {llm.model}")
        print(f"   服务地址: {llm.base_url}")
        print(f"   思考模式: {'已关闭(加速生成)' if _DISABLE_THINKING else '已开启'}")

        _llm_instance = RateLimitRetryLLM(llm)

    return _llm_instance


def reset_llm():
    """重置LLM实例(用于测试或重新配置)"""
    global _llm_instance
    _llm_instance = None
