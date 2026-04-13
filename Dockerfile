# 1. 核心替换：改用阿里云官方(PAI)提供的内网 PyTorch 镜像，瞬间拉取！
FROM registry.cn-hangzhou.aliyuncs.com/pai-dlc/pytorch-training:2.1.0-gpu-py310-cu121-ubuntu22.04

# 2. 彻底干掉弹窗询问
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Shanghai

WORKDIR /app

# 3. 安装系统工具
RUN apt-get update && apt-get install -y git ffmpeg wget

# 4. GitHub 代理：使用国内加速节点拉取源码
RUN git clone https://mirror.ghproxy.com/https://github.com/k2-fsa/OmniVoice.git .

# 5. Pip 代理：强制使用清华大学镜像源安装 Python 依赖，防止卡顿
RUN pip install --no-cache-dir fastapi uvicorn torchaudio transformers modelscope -i https://pypi.tuna.tsinghua.edu.cn/simple

# 6. 运行下载脚本，让国内的阿里云服务器去国内的魔搭社区拉取模型
COPY download_model.py .
RUN python download_model.py

EXPOSE 9880

CMD ["uvicorn", "server:app", "--host", "0.0.0.0", "--port", "9880"]
