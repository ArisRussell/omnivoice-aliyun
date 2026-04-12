# 1. 使用官方的 PyTorch 基础镜像
FROM pytorch/pytorch:2.1.0-cuda12.1-cudnn8-runtime

# 👉 核心修复：声明非交互模式，并设置默认时区，彻底干掉弹窗询问！
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Shanghai

# 2. 设置工作目录
WORKDIR /app

# 3. 安装系统必备工具 (现在它不会再卡住问你时区了)
RUN apt-get update && apt-get install -y git ffmpeg wget

# 4. 克隆 OmniVoice 源码并安装 Python 依赖
RUN git clone https://github.com/k2-fsa/OmniVoice.git .
RUN pip install --no-cache-dir fastapi uvicorn torchaudio transformers modelscope

# 5. 把下载脚本放进镜像
COPY download_model.py .

# 👉 强烈建议：为了防止下一步因为下载几十G模型导致超时，先注释掉这行。
# 等镜像打包成功并在函数计算跑起来后，让它在启动时去下载。
# RUN python download_model.py

# 6. 暴露 9880 端口给外部访问
EXPOSE 9880

# 7. 容器启动时的命令
CMD ["uvicorn", "server:app", "--host", "0.0.0.0", "--port", "9880"]
