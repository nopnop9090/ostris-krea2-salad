# Ostris AI Toolkit for Salad + always-preload Krea-2-Raw
#
# Does NOT use saladtechnologies/*-flux1-dev (Kelpie/Flux recipe).
# Base: official ostris/aitoolkit (interactive UI on :8675).
#
# At every start, if /models/Krea-2-Raw/raw.safetensors is missing,
# downloads krea/Krea-2-Raw using HF_TOKEN (gated). Then starts the UI.

FROM ostris/aitoolkit:latest

USER root
WORKDIR /app

RUN pip install --break-system-packages --no-cache-dir -U "huggingface_hub[hf_transfer]" hf_transfer \
    && mkdir -p /models /root/workspace

COPY download-krea2.sh /usr/local/bin/download-krea2.sh
COPY download-qwen-vl.sh /usr/local/bin/download-qwen-vl.sh
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/download-krea2.sh /usr/local/bin/download-qwen-vl.sh /usr/local/bin/entrypoint.sh

ENV KREA2_REPO=krea/Krea-2-Raw \
    KREA2_DIR=/models/Krea-2-Raw \
    QWEN_VL_REPO=Qwen/Qwen3-VL-8B-Instruct \
    QWEN_VL_DIR=/models/Qwen3-VL-8B-Instruct \
    PRELOAD_QWEN_VL=0 \
    HF_HUB_ENABLE_HF_TRANSFER=1 \
    HOST=:: \
    PORT=8675

# HF_TOKEN and AI_TOOLKIT_AUTH must be set at runtime (Salad ENV). Never commit tokens.

EXPOSE 8675
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
