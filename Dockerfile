# Wechsel von Buster (EOL) auf Bullseye (LTS)
FROM python:3.8-slim-bullseye

RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    ffmpeg \
    libsm6 \
    libxext6 \
    libgl1 \
    libglib2.0-0 \
    wget \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

RUN pip install --no-cache-dir torch==1.12.1+cu113 torchvision==0.13.1+cu113 torchaudio==0.12.1 --extra-index-url https://download.pytorch.org/whl/cu113

RUN pip install --no-cache-dir \
    numpy==1.23.5 \
    face_alignment==1.3.5 \
    librosa \
    yacs \
    scipy==1.10.1 \
    kornia==0.6.8 \
    tqdm \
    imageio \
    imageio-ffmpeg \
    pydub \
    av \
    safetensors \
    gfpgan==1.3.8 \
    facexlib==0.3.0

RUN git clone https://github.com/OpenTalker/SadTalker.git
WORKDIR /app/SadTalker
RUN bash scripts/download_models.sh

CMD ["python", "inference.py", "--help"]
