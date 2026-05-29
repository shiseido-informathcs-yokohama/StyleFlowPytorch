FROM nvidia/cuda:11.8.0-cudnn8-devel-ubuntu22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Tokyo

RUN apt-get update && apt-get install -y \
    python3.10 \
    python3.10-dev \
    python3-pip \
    cmake \
    build-essential \
    ninja-build \
    libboost-all-dev \
    libssl-dev \
    libffi-dev \
    libgl1-mesa-glx \
    libglib2.0-0 \
    libsm6 \
    libxext6 \
    libxrender-dev \
    git \
    wget \
    && rm -rf /var/lib/apt/lists/*

RUN update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.10 1

RUN python3 -m pip install --upgrade pip

RUN pip install torch==2.0.1+cu118 torchvision==0.15.2+cu118 \
    --extra-index-url https://download.pytorch.org/whl/cu118
    
RUN pip install \
    streamlit==1.12.0 \
    altair==4.2.2 \
    opencv-python-headless==4.7.0.72 \
    numpy==1.24.3 \
    scipy==1.10.1 \
    scikit-learn \
    matplotlib \
    torchdiffeq \
    pyyaml \
    tensorboard \
    dlib \
    Pillow==9.5.0 \
    ninja \
    tqdm


ENV TORCHI_EXTENSION_DIR=/tmp/torch_extensions

WORKDIR /app
COPY . .

RUN mkdir -p /root/.streamlit && \
    printf '[server]\nport = 8501\nheadless = true\nenableCORS = false\n' \
    > /root/.streamlit/config.toml

EXPOSE 8501

WORKDIR /app/webui
CMD ["bash", "-c", "CUDA_VISIBLE_DEVICES=0 streamlit run app.py --server.port 8501 --server.address 0.0.0.0"]
