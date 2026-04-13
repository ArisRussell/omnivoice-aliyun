FROM pytorch/pytorch:2.1.0-cuda12.1-cudnn8-runtime
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Shanghai
WORKDIR /app

RUN apt-get update && apt-get install -y git ffmpeg wget
RUN git clone https://github.com/k2-fsa/OmniVoice.git .
RUN pip install --no-cache-dir fastapi uvicorn torchaudio transformers huggingface_hub

# 👉 这一步最关键：把仓库里的 python 脚本拷贝到容器里
COPY download_model.py .
COPY server.py .

# 运行下载脚本
RUN python download_model.py

EXPOSE 9880
# 启动命令
CMD ["uvicorn", "server:app", "--host", "0.0.0.0", "--port", "9880"]
