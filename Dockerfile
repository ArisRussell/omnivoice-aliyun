# 1. 使用官方的 PyTorch 基础镜像（自带 CUDA 环境）
FROM pytorch/pytorch:2.1.0-cuda12.1-cudnn8-runtime

# 2. 设置工作目录
WORKDIR /app

# 3. 安装系统必备工具
RUN apt-get update && apt-get install -y git ffmpeg wget

# 4. 克隆 OmniVoice 源码并安装 Python 依赖（加入 modelscope）
RUN git clone https://github.com/k2-fsa/OmniVoice.git .
RUN pip install --no-cache-dir fastapi uvicorn torchaudio transformers modelscope

# 5. 把我们刚才写的下载脚本放进镜像里，并在打包时就运行它（把模型封印进镜像）
COPY download_model.py .
RUN python download_model.py

# 6. 暴露 9880 端口给外部访问
EXPOSE 9880

# 7. 容器启动时的命令（此处假设官方启动脚本名为 server.py，实例为 app）
CMD ["uvicorn", "server:app", "--host", "0.0.0.0", "--port", "9880"]
