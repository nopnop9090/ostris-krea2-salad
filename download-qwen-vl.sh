#!/bin/bash
# Optional captioning model preload (off by default).
# Enable: PRELOAD_QWEN_VL=1 in Salad ENV.
set -euo pipefail

REPO="${QWEN_VL_REPO:-Qwen/Qwen3-VL-8B-Instruct}"
DIR="${QWEN_VL_DIR:-/models/Qwen3-VL-8B-Instruct}"

if [[ -z "${HF_TOKEN:-}" ]]; then
  echo "HF_TOKEN required for ${REPO}" >&2
  exit 1
fi

# Heuristic: snapshot already present if config + some weights exist
if [[ -f "${DIR}/config.json" ]] && compgen -G "${DIR}/*.safetensors" >/dev/null 2>&1; then
  echo "Qwen VL already present at ${DIR}"
  exit 0
fi

echo "Downloading ${REPO} -> ${DIR} (captioning; optional)"
mkdir -p "${DIR}"
export HF_HUB_ENABLE_HF_TRANSFER="${HF_HUB_ENABLE_HF_TRANSFER:-1}"

huggingface-cli download "${REPO}" \
  --local-dir "${DIR}" \
  --token "${HF_TOKEN}"

echo "Qwen VL download complete: ${DIR}"
du -sh "${DIR}" || true
