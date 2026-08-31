FROM python:3.11-slim
LABEL maintainer="szhang"
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    wget \
    curl \
    zlib1g-dev \
    libgomp1 \
    && rm -rf /var/lib/apt/lists/*
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt
COPY . /app/
CMD ["python", "run_analysis.py"]
CMD ["bash"]
