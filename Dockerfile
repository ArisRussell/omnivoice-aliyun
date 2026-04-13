# 1. 基础环境保持不变
FROM pytorch/pytorch:2.1.0-cuda12.1-cudnn8-runtime

# 2. 环境设置
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Shanghai
WORKDIR /app

# 3. 安装系统工具
RUN apt-get update && apt-get install -y git ffmpeg wget

# 4. 克隆源码
RUN git clone https://github.com/k2-fsa/OmniVoice.git .

# 5. 👉 核心修正：补全 librosa, soundfile, scipy 等核心音频依赖
RUN pip install --no-cache-dir fastapi uvicorn torchaudio transformers huggingface_hub librosa soundfile scipy

# 6. 复制脚本并下载模型
COPY download_model.py .
COPY server.py .
RUN python download_model.py

# 7. 端口与启动
EXPOSE 9880
CMD ["uvicorn", "server:app", "--host", "0.0.0.0", "--port", "9880"]
