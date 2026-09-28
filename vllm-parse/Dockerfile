# vLLM with the open_clip package that Nemotron Parse's trust-remote-code
# modeling file imports at load time (stock image lacks it).
#
# --no-deps keeps pip away from the image's own torch/torchvision builds
# (aarch64/CUDA-specific — a resolver "upgrade" would break them). ftfy is
# open_clip's only missing runtime dep; torch, torchvision and regex are
# already in the image.
FROM vllm/vllm-openai:v0.20.0

RUN python3 -m pip install --no-cache-dir --no-deps open-clip-torch && \
    python3 -m pip install --no-cache-dir ftfy albumentations && \
    python3 -c "import torch, open_clip, albumentations, cv2; print('open_clip', open_clip.__version__, '| albumentations', albumentations.__version__, '| torch', torch.__version__)"
