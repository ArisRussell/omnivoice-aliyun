# 1. 使用官方的 PyTorch 基础镜像（海外机器拉取极快）
FROM pytorch/pytorch:2.1.0-cuda12.1-cudnn8-runtime

# 2. 彻底干掉弹窗询问
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Shanghai

WORKDIR /app

# 3. 安装系统必备工具
RUN apt-get update && apt-get install -y git ffmpeg wget

# 4. 直接克隆源码
RUN git clone https://github.com/k2-fsa/OmniVoice.git .

# 5. 安装 Python 依赖（注意去掉了 modelscope，加上了 huggingface_hub）
RUN pip install --no-cache-dir fastapi uvicorn torchaudio transformers huggingface_hub

# 6. 把下载脚本放进镜像，并在打包时运行（把模型封印进镜像）
COPY download_model.py .
RUN python download_model.py

# 7. 暴露端口并启动
EXPOSE 9880
CMD ["uvicorn", "server:app", "--host", "0.0.0.0", "--port", "9880"]
