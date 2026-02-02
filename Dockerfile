# Build stage for TensorRT-LLM project
FROM nvidia/cuda:13.0.0-devel-ubuntu24.04

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive \
    PYTHONUNBUFFERED=1 \
    PATH="/root/.cargo/bin:/workspace/trrt-llm/.venv/bin:$PATH"

# Set working directory
WORKDIR /workspace/trrt-llm

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    git \
    nano \
    python3.12-dev \
    libopenmpi-dev \
    && rm -rf /var/lib/apt/lists/*

# Install uv
RUN curl -LsSf https://astral.sh/uv/install.sh | sh

# Copy dependency files
COPY pyproject.toml uv.lock ./

# Install dependencies using uv
# --frozen ensures we use the exact versions from uv.lock
RUN /root/.cargo/bin/uv sync --frozen

# Keep the container running
CMD ["/bin/bash", "-c", "sleep infinity"]