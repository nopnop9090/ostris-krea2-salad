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
  ls -lh "${DIR}/raw.safetensors"
  exit 0
fi

echo "Downloading ${REPO} -> ${DIR}"
echo "Ostris needs raw.safetensors (~26GB) + small companion files — not the full ~62GB HF tree."
mkdir -p "${DIR}"
export HF_HUB_ENABLE_HF_TRANSFER="${HF_HUB_ENABLE_HF_TRANSFER:-1}"

# Include only what Ostris krea2 loader needs locally:
# - raw.safetensors (DiT)
# - vae/ (optional but useful)
# - tokenizer / configs if present
# Exclude duplicate transformer/*.safetensors shards and text_encoder weights
# (Qwen TE is pulled separately by Ostris if unset).
huggingface-cli download "${REPO}" \
  --local-dir "${DIR}" \
  --token "${HF_TOKEN}" \
  --include "raw.safetensors" \
  --include "model_index.json" \
  --include "vae/*" \
  --include "tokenizer/*" \
  --include "tokenizer_2/*" \
  --include "*.json" \
  --exclude "transformer/*.safetensors" \
  --exclude "text_encoder/**" \
  --exclude "text_encoder_2/**" \
  --exclude "images/**"

if [[ ! -f "${DIR}/raw.safetensors" ]]; then
  echo "ERROR: raw.safetensors missing after download. Layout:" >&2
  find "${DIR}" -maxdepth 3 -type f | head -80 >&2
  exit 1
fi

echo "Download complete."
ls -lh "${DIR}/raw.safetensors"
du -sh "${DIR}" || true
