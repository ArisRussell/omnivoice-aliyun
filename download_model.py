from modelscope import snapshot_download
import os

# 这里设定模型存放的路径
os.makedirs('/app/models', exist_ok=True)

print("开始从 ModelScope 极速拉取 OmniVoice 模型...")
# 注意：'k2-fsa/omnivoice' 为示例，具体 ID 请参考 OmniVoice 官方在魔搭的最新命名
model_dir = snapshot_download('k2-fsa/omnivoice', cache_dir='/app/models')

print(f"模型下载完成，保存在: {model_dir}")
