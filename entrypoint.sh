#!/bin/bash
set -euo pipefail

echo "=== ostris-krea2-salad entrypoint ==="

if [[ -z "${HF_TOKEN:-}" ]]; then
  echo "ERROR: HF_TOKEN is required (gated model krea/Krea-2-Raw). Set it in Salad ENV." >&2
  exit 1
fi

# Always ensure Krea-2-Raw is on disk before UI (skip if already present)
 /usr/local/bin/download-krea2.sh

# Optional (later): captioning weights — enable with PRELOAD_QWEN_VL=1
if [[ "${PRELOAD_QWEN_VL:-0}" == "1" ]]; then
  /usr/local/bin/download-qwen-vl.sh || echo "Qwen VL download failed (continuing)" >&2
fi

# Convenience paths for Ostris configs / UI
mkdir -p /app/ai-toolkit/models 2>/dev/null || true
ln -sfn "${KREA2_DIR}" /app/ai-toolkit/models/Krea-2-Raw
ln -sfn "${KREA2_DIR}" /models/Krea-2-Raw
echo "Krea2 ready at ${KREA2_DIR}"
ls -lh "${KREA2_DIR}/raw.safetensors" 2>/dev/null || ls -lh "${KREA2_DIR}" | head -20

export HOST="${HOST:-::}"
export PORT="${PORT:-8675}"

if [[ -x /start.sh ]]; then
  echo "Starting Ostris via /start.sh (UI :${PORT})"
  exec /start.sh
fi

echo "Fallback: npm run start"
cd /app/ai-toolkit/ui
exec npm run start
