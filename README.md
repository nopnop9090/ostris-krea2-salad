# Custom Ostris AI Toolkit image for SaladCloud (interactive UI + Krea-2-Raw)

Not the official Salad Flux/Kelpie recipe. Base image: [`ostris/aitoolkit`](https://hub.docker.com/r/ostris/aitoolkit).

## Behaviour

1. Requires `HF_TOKEN` (read-only OK) — model is gated.
2. On start, downloads [`krea/Krea-2-Raw`](https://huggingface.co/krea/Krea-2-Raw) (~62 GB) to `/models/Krea-2-Raw` if `raw.safetensors` is missing.
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
- Disk **≥ 120 GB** (model ~62 GB + toolkit + outputs)
- First boot: not Ready until download + UI are up (can be 30–90+ min depending on node bandwidth)
- Do not use Salad’s `…-flux1-dev-kelpie` image for this workflow

## Build

```bash
docker build -t ghcr.io/nopnop9090/ostris-krea2-salad:latest .
docker push ghcr.io/nopnop9090/ostris-krea2-salad:latest
```

Model is **not** baked into the image (62 GB). It is fetched at container start with `HF_TOKEN`.
