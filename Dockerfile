Ini Dockerfile yg compile nya belakangan via bash ke container

# Stage 1: Build environment with CUDA and necessary tools (Ubuntu-based)
FROM nvidia/cuda:12.3.1-devel-ubuntu20.04 AS builder

ENV DEBIAN_FRONTEND=noninteractive

WORKDIR /app

# Install essential build tools (Ubuntu-specific packages)
RUN apt-get update && apt-get install -y \
    make \
    cmake \
    libtool \
    libjson-c-dev \
    libcurl4-openssl-dev \
    libc6-dev-i386 \
    wget \
    g++ \
    && rm -rf /var/lib/apt/lists/*

# Download and install cuDNN manually
# https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/
RUN wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/libcudnn8_8.2.1.32-1+cuda11.3_amd64.deb \
    && dpkg -i libcudnn8_8.2.1.32-1+cuda11.3_amd64.deb \
    && rm libcudnn8_8.2.1.32-1+cuda11.3_amd64.deb

# Copy project files
COPY . .

# Compile each project with nvcc
# Commented out the compilation commands
# RUN make -C projects/CMLUtils
# RUN make -C projects/CardioLockGenerator
# RUN make -C project3
# Add more commands for additional projects
##------------------------------------------------------------------------------------

# Stage 2: Minimal runtime environment (Ubuntu-based)
FROM nvidia/cuda:12.3.1-runtime-ubuntu20.04

WORKDIR /app

# Copy compiled binaries from the builder stage
COPY --from=builder /app/CardioLockGenerator/bin/cardiolockgen .
# COPY --from=builder /app/project3/bin/project3_binary .
# Adjust paths for additional projects

# Run the binary files (adjust commands as needed)
CMD ["./cardiolockgen"]
# CMD ["./project2_binary"]
# CMD ["./project3_binary"]
# Add more CMDs for additional projects
