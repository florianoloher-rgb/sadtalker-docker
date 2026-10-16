FROM python:3.8-slim-bullseye

RUN printf 'deb http://snapshot.debian.org/archive/debian/20260825T000000Z bullseye main\ndeb http://snapshot.debian.org/archive/debian-security/20260825T000000Z bullseye-security main\n' > /etc/apt/sources.list && \
    echo 'Acquire::Check-Valid-Until "false";' > /etc/apt/apt.conf.d/99snapshot

# Build-Tools hinzugefügt, damit alle Pakete kompiliert werden können
RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    ffmpeg \
    libsm6 \
    libxext6 \
    libgl1 \
    libglib2.0-0 \
    wget \
    build-essential \
    gcc \
    g++ \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# PyTorch zuerst
RUN pip install --no-cache-dir torch==1.12.1+cu113 torchvision==0.13.1+cu113 torchaudio==0.12.1 --extra-index-url https://download.pytorch.org/whl/cu113

# filterpy aus dem funktionierenden Fork installieren (behebt den setup.py-Bug)
RUN pip install --no-cache-dir git+https://github.com/rodjjo/filterpy.git

# basisr und facexlib und gfpgan (benötigen filterpy)
RUN pip install --no-cache-dir \
    basicsr==1.4.2 \
    facexlib==0.3.0 \
    gfpgan==1.3.8

# Restliche Abhängigkeiten
RUN pip install --no-cache-dir \
    numpy==1.23.5 \
    face_alignment==1.3.5 \
    librosa==0.9.2 \
    yacs==0.1.8 \
    scipy==1.10.1 \
    kornia==0.6.8 \
    tqdm \
    imageio==2.19.3 \
    imageio-ffmpeg==0.4.7 \
    pydub==0.25.1 \
    av==10.0.0 \
    safetensors \
    joblib==1.1.0 \
    scikit-image==0.19.3 \
    resampy==0.3.1

RUN git clone https://github.com/OpenTalker/SadTalker.git
WORKDIR /app/SadTalker
RUN bash scripts/download_models.sh

CMD ["python", "inference.py", "--help"]
