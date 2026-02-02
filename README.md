# TensorRT-LLM with CUDA 13 (Optimized)

This repository provides an optimized environment for running TensorRT-LLM on Ubuntu 24.04 with CUDA 13.0.

## 🚀 Image Features

This Docker image is designed for performance, reproducibility, and ease of use:

- **Base Image**: `nvidia/cuda:13.0.0-devel-ubuntu24.04`
- **Modern Tooling**: Powered by [uv](https://github.com/astral-sh/uv) for lightning-fast package management.
- **Pre-installed Dependencies**:
  - **PyTorch**: 2.9.1+cu130
  - **TensorRT-LLM**: 1.3.0rc1
  - **System Deps**: `libopenmpi-dev`, `python3.12-dev`, `nano`, `git`, `curl`
- **Automatic Environment**: The virtual environment is located at `/workspace/trrt-llm/.venv` and is **automatically activated** when you open a shell in the container.

## 🛠 Usage

### Building the Image
```sh
docker build -t trt-llm-opt .
```

### Running the Container
Ensure you have the [NVIDIA Container Toolkit](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html) installed.
```sh
docker run --gpus all -it --rm trt-llm-opt
```

### Verification
Once inside the container, you can verify the installation immediately:
```python
python -c "import torch; import tensorrt_llm; print(f'Torch: {torch.__version__}'); print('TensorRT-LLM installed successfully!')"
```

## 📦 Dependency Management
The environment is managed via `pyproject.toml` and `uv.lock`. 

- To add new packages: `uv add <package>`
- To sync the environment: `uv sync`

---
*Note: The working directory is set to `/workspace/trrt-llm`.*
