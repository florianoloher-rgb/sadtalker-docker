FROM python:3.8-slim-bullseye

RUN printf 'deb http://snapshot.debian.org/archive/debian/20260825T000000Z bullseye main\ndeb http://snapshot.debian.org/archive/debian-security/20260825T000000Z bullseye-security main\n' > /etc/apt/sources.list && \
    echo 'Acquire::Check-Valid-Until "false";' > /etc/apt/apt.conf.d/99snapshot

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
    cmake \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

RUN git clone https://github.com/OpenTalker/SadTalker.git
WORKDIR /app/SadTalker

RUN pip install --no-cache-dir --upgrade pip setuptools wheel

RUN pip install --no-cache-dir torch==1.12.1+cu113 torchvision==0.13.1+cu113 torchaudio==0.12.1 --extra-index-url https://download.pytorch.org/whl/cu113

RUN pip install --no-cache-dir -r requirements.txt

RUN pip install --no-cache-dir gfpgan==1.3.8

RUN bash scripts/download_models.sh

CMD ["python", "inference.py", "--help"]
