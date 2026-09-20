#!/bin/bash
set -euo pipefail

REPO="${KREA2_REPO:-krea/Krea-2-Raw}"
DIR="${KREA2_DIR:-/models/Krea-2-Raw}"

if [[ -z "${HF_TOKEN:-}" ]]; then
  echo "HF_TOKEN is required to download ${REPO}" >&2
  exit 1
fi

if [[ -f "${DIR}/raw.safetensors" ]]; then
  echo "Krea2 already present: ${DIR}/raw.safetensors"
  exit 0
fi

echo "Downloading ${REPO} -> ${DIR} (gated; ~62GB — first start takes a while)"
mkdir -p "${DIR}"
export HF_HUB_ENABLE_HF_TRANSFER="${HF_HUB_ENABLE_HF_TRANSFER:-1}"

# huggingface-cli is provided by huggingface_hub
huggingface-cli download "${REPO}" \
  --local-dir "${DIR}" \
  --token "${HF_TOKEN}"

if [[ ! -f "${DIR}/raw.safetensors" ]]; then
  echo "ERROR: raw.safetensors missing after download. Layout:" >&2
  find "${DIR}" -maxdepth 3 -type f | head -80 >&2
  exit 1
fi

echo "Download complete."
ls -lh "${DIR}/raw.safetensors"
