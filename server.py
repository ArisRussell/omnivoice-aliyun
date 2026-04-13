import os
import torch
import torchaudio
from fastapi import FastAPI, Request
from fastapi.responses import Response
from omnivoice import OmniVoice
from huggingface_hub import snapshot_download

app = FastAPI()

# 1. 自动加载模型（从镜像里的缓存路径读取）
print("正在加载 OmniVoice 模型，请稍候...")
model_dir = snapshot_download(repo_id='k2-fsa/omnivoice')
# 初始化模型引擎
engine = OmniVoice(model_dir)
if torch.cuda.is_available():
    engine.to("cuda")
print("模型加载成功！服务已就绪。")

@app.post("/v1/audio/speech")
async def text_to_speech(request: Request):
    # 接收来自“阅读”App 的请求
    data = await request.json()
    text = data.get("input", "")
    
    if not text:
        return Response(status_code=400, content="Input text is empty")

    # 2. 调用模型生成语音
    # 注意：这里使用了默认参数，后续你可以根据需求调整音色(voice)
    with torch.no_grad():
        audio = engine.generate(text)
    
    # 3. 将音频保存为临时文件并返回给手机
    temp_file = "output.mp3"
    torchaudio.save(temp_file, audio.cpu(), 24000)
    
    with open(temp_file, "rb") as f:
        return Response(content=f.read(), media_type="audio/mpeg")

@app.get("/")
def health_check():
    return {"status": "ok", "message": "OmniVoice Serverless is running!"}
