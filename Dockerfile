# Build stage for TensorRT-LLM project
FROM nvidia/cuda:13.0.0-devel-ubuntu24.04

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive \
    PYTHONUNBUFFERED=1 \
    PATH="/workspace/trrt-llm/.venv/bin:$PATH"

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
COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

# Copy dependency files
COPY pyproject.toml uv.lock ./

# Install dependencies using uv
# --frozen ensures we use the exact versions from uv.lock
RUN uv sync --frozen

# Keep the container running
CMD ["/bin/bash", "-c", "sleep infinity"]