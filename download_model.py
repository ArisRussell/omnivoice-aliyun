from huggingface_hub import snapshot_download

print("开始从 HuggingFace 极速拉取 OmniVoice 模型...")
# 直接拉取到默认缓存目录，这样 OmniVoice 启动时会自动识别，不需要修改路径配置
snapshot_download(repo_id='k2-fsa/omnivoice')
print("模型下载完成！")
