# Custom Ostris AI Toolkit image for SaladCloud (interactive UI + Krea-2-Raw)

Not the official Salad Flux/Kelpie recipe. Base image: [`ostris/aitoolkit`](https://hub.docker.com/r/ostris/aitoolkit).

## Behaviour

1. Requires `HF_TOKEN` (read-only OK) — model is gated.
2. On start, downloads [`krea/Krea-2-Raw`](https://huggingface.co/krea/Krea-2-Raw) **`raw.safetensors` (~26 GB)** plus small companion files (VAE/tokenizer/json) to `/models/Krea-2-Raw` if missing. Skips redundant transformer/text_encoder shards from the full HF tree.
3. Starts Ostris UI on port **8675** (IPv6 dual-stack via upstream `/start.sh`).

## Salad ENV

| Variable | Required | Example |
|----------|----------|---------|
| `HF_TOKEN` | yes | Hugging Face read token |
| `AI_TOOLKIT_AUTH` | recommended | UI password |
| `KREA2_REPO` | no | `krea/Krea-2-Raw` |
| `KREA2_DIR` | no | `/models/Krea-2-Raw` |

## Deploy notes

- Container Gateway port **8675**
- Disk **≥ 80 GB** (model ~26 GB + toolkit + outputs)
- First boot: not Ready until download + UI are up (download ~26 GB)
- Do not use Salad’s `…-flux1-dev-kelpie` image for this workflow

## Build

```bash
docker build -t ghcr.io/nopnop9090/ostris-krea2-salad:latest .
docker push ghcr.io/nopnop9090/ostris-krea2-salad:latest
```

Model weights are **not** baked into the image; they are fetched at container start with `HF_TOKEN` (~26 GB `raw.safetensors`).
